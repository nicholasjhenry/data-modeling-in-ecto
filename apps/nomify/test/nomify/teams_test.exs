defmodule Nomify.TeamsTest do
  use Nomify.DataCase

  alias Nomify.Teams

  describe "teams" do
    alias Nomify.Teams.Team

    import Nomify.DirectoryFixtures
    import Nomify.TeamsFixtures

    @invalid_attrs %{format: nil, description: nil}

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Teams.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Teams.get_team!(team.id).id == team.id
    end

    test "create_team/1 with valid data creates a team" do
      valid_attrs = %{format: :none, description: "some description"}

      assert {:ok, %Team{} = team} = Teams.create_team(valid_attrs)
      assert team.format == :none
      assert team.description == "some description"
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      update_attrs = %{format: :single, description: "some updated description"}

      assert {:ok, %Team{} = team} = Teams.update_team(team, update_attrs)
      assert team.format == :single
      assert team.description == "some updated description"
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Teams.update_team(team, @invalid_attrs)

      assert Teams.team_equal?(
               team,
               Teams.get_team!(team.id)
             )
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Teams.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Teams.change_team(team)
    end
  end

  describe "team_members" do
    alias Nomify.Teams.TeamMember

    import Nomify.DirectoryFixtures
    import Nomify.TeamsFixtures

    setup do
      team = team_fixture()
      person = person_fixture()

      %{team: team, person: person}
    end

    @invalid_attrs %{security_level: nil}

    test "list_team_members/0 returns all team_members" do
      team_member = team_member_fixture()
      assert [listed_team_member] = Teams.list_team_members()
      assert listed_team_member.id == team_member.id
    end

    test "get_team_member!/1 returns the team_member with given id" do
      team_member = team_member_fixture()
      team = team_member.team
      assert fetched_team_member = Teams.get_team_member!(team, team_member.id)
      assert fetched_team_member.id == team_member.id
    end

    test "create_team_member/1 with valid data creates a team_member", %{
      team: team,
      person: person
    } do
      assert {:ok, %TeamMember{} = team_member} =
               Teams.create_team_member(team, person)

      assert team_member.role == :member
      assert team_member.privileges.flags == []
      assert team_member.security_level == :low
    end

    test "create_team_member/1 enforces a person must have a valid email address business rule",
         %{
           team: team
         } do
      invalid_person = person_fixture(email: nil)

      assert {:error, changeset} =
               Teams.create_team_member(team, invalid_person)

      assert "Person cannot be team member. Invalid email." in errors_on(changeset).business_rule
    end

    test "create_team_member/1 enforces one person per team business rule", %{
      team: team,
      person: person
    } do
      assert {:ok, %TeamMember{} = _team_member} =
               Teams.create_team_member(team, person)

      assert {:error, changeset} =
               Teams.create_team_member(team, person)

      assert "Tried to add person twice to team." in errors_on(changeset).business_rule
    end

    test "update_team_member/2 with valid data updates the team_member" do
      # default role :member
      team_member = team_member_fixture()
      update_attrs = %{security_level: :medium}

      assert {:ok, %TeamMember{} = team_member} =
               Teams.update_team_member(team_member, update_attrs)

      assert team_member.role == :member
      assert team_member.security_level == :medium
    end

    test "update_team_member/2 with invalid data returns error changeset" do
      team_member = team_member_fixture()
      team = team_member.team

      assert {:error, %Ecto.Changeset{}} =
               Teams.update_team_member(team_member, @invalid_attrs)

      assert Teams.team_member_equal?(
               team_member,
               Teams.get_team_member!(team, team_member.id)
             )
    end

    test "update_team_member_role/2 with valid data updates the team_member role" do
      team_member = team_member_fixture()
      update_attrs = %{role: :member}

      assert {:ok, %TeamMember{} = team_member} =
               Teams.update_team_member_role(team_member, update_attrs)

      assert team_member.role == :member
    end

    test "update_team_member_role/2 with invalid data returns error changeset" do
      team_member = team_member_fixture()
      team = team_member.team

      update_attrs = %{role: :foo}

      assert {:error, %Ecto.Changeset{}} =
               Teams.update_team_member_role(team_member, update_attrs)

      assert Teams.team_member_equal?(
               team_member,
               Teams.get_team_member!(team, team_member.id)
             )
    end

    test "update_team_member_role/2 enforces team chair business rule for multiple-chair team" do
      team = team_fixture(%{format: :multiple})
      team_member = team_member_fixture(team)

      assert {:ok, team_member} =
               Teams.update_team_member_role(team_member, %{role: :chair})

      assert team_member.role == :chair

      team_member = team_member_fixture(team)

      assert {:ok, team_member} =
               Teams.update_team_member_role(team_member, %{role: :chair})

      assert team_member.role == :chair
    end

    test "update_team_member_role/2 enforces team chair business rule for single-chair team" do
      team = team_fixture(%{format: :single})
      team_member = team_member_fixture(team)

      assert {:ok, _team_member} =
               Teams.update_team_member_role(team_member, %{role: :chair})

      team_member = team_member_fixture(team)

      assert {:error, changeset} =
               Teams.update_team_member_role(team_member, %{role: :chair})

      "Tried to add another chair team member to single chair team." in errors_on(changeset).role
    end

    test "update_team_member_role/2 enforces team chair business rule for none-chair team" do
      team = team_fixture(%{format: :none})
      team_member = team_member_fixture(team)

      assert {:error, changeset} =
               Teams.update_team_member_role(team_member, %{role: :chair})

      "Tried to add chair team member to no chairs team." in errors_on(changeset).role
    end

    test "update_team_member_privileges/2 with valid data updates the team_member privileges" do
      team_member = team_member_fixture()
      update_attrs = %{delete: "true", nominate: "false"}

      assert {:ok, %TeamMember{} = team_member} =
               Teams.update_team_member_privileges(team_member, update_attrs)

      assert team_member.privileges.flags == [:delete]
    end

    test "delete_team_member/1 deletes the team_member" do
      team_member = team_member_fixture()
      team = team_member.team

      assert {:ok, %TeamMember{}} = Teams.delete_team_member(team_member)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team_member!(team, team_member.id) end
    end

    test "change_team_member/1 returns a team_member changeset" do
      team_member = team_member_fixture()
      assert %Ecto.Changeset{} = Teams.change_team_member(team_member)
    end
  end
end
