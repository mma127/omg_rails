require "rails_helper"

RSpec.describe CompanyService do
  let!(:player) { create :player }
  subject { described_class.new(player) }

  let(:name) { "My new company" }
  let!(:ruleset) { create :ruleset }
  let(:faction) { create :faction }
  let(:doctrine) { create :doctrine, faction: faction }
  let!(:restriction_faction) { create :restriction, faction: faction, doctrine: nil, unlock: nil }
  let!(:restriction_doctrine) { create :restriction, faction: nil, doctrine: doctrine, unlock: nil }
  let(:unit1) { create :unit }
  let(:unit2) { create :unit }
  let(:unit3) { create :unit }
  let!(:restriction_unit1) { create :base_restriction_unit, unit: unit1, pop: 4, resupply: 4, resupply_max: 6, company_max: 10, restriction: restriction_faction }
  let!(:restriction_unit2) { create :base_restriction_unit, unit: unit2, pop: 7, resupply: 2, resupply_max: 5, company_max: 5, restriction: restriction_faction }
  let!(:restriction_unit3) { create :base_restriction_unit, unit: unit3, pop: 13, resupply: 1, resupply_max: 1, company_max: 2, restriction: restriction_doctrine }

  context "#create_company" do
    it "creates the Company with valid params" do
      company = subject.create_company(doctrine, name)

      expect(company).to be_valid
      expect(company.name).to eq name
      expect(company.faction).to eq faction
      expect(company.doctrine).to eq doctrine
      expect(company.ruleset).to eq ruleset
      expect(company.man).to eq ruleset.starting_man
      expect(company.mun).to eq ruleset.starting_mun
      expect(company.fuel).to eq ruleset.starting_fuel
      expect(company.pop).to eq 0
    end

    it "builds the Company's AvailableUnits" do
      company = subject.create_company(doctrine, name)
      expect(company.available_units.size).to eq 3
    end

    it "raises a validation error when the Player has too many Companies of that side" do
      create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset
      create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset
      expect { subject.create_company(doctrine, name) }.to raise_error(
                                                             CompanyService::CompanyCreationValidationError,
                                                             "Player #{player.id} has too many #{faction.side} companies, cannot create another one.")
    end
  end

  context "#update_company_squads" do
    context "when there are no existing Squads in the Company" do
      let!(:squads_param) {
        [
          {
            squad_id: nil,
            unit_id: unit1.id,
            name: nil,
            vet: 0,
            tab: "core",
            index: 0
          },
          {
            squad_id: nil,
            unit_id: unit2.id,
            name: nil,
            vet: 0,
            tab: "core",
            index: 0
          },
          {
            squad_id: nil,
            unit_id: unit2.id,
            name: nil,
            vet: 0,
            tab: "core",
            index: 1
          },
          {
            squad_id: nil,
            unit_id: unit2.id,
            name: nil,
            vet: 0,
            tab: "infantry",
            index: 0
          },
          {
            squad_id: nil,
            unit_id: unit2.id,
            name: nil,
            vet: 0,
            tab: "infantry",
            index: 1
          },
          {
            squad_id: nil,
            unit_id: unit1.id,
            name: nil,
            vet: 0,
            tab: "infantry",
            index: 2
          },
          {
            squad_id: nil,
            unit_id: unit1.id,
            name: nil,
            vet: 0,
            tab: "infantry",
            index: 2
          },
          {
            squad_id: nil,
            unit_id: unit3.id,
            name: nil,
            vet: 0,
            tab: "armour",
            index: 1
          }
        ]
      }

      before do
        @company = subject.create_company(doctrine, name)
      end

      it "creates all input Squads for the Company" do
        squads, _ = subject.update_company_squads(@company, squads_param)
        expect(squads.size).to eq squads_param.size

        expect(squads.where(available_unit: AvailableUnit.find_by(company: @company, unit: unit1)).size).to eq 3
        expect(squads.where(available_unit: AvailableUnit.find_by(company: @company, unit: unit2)).size).to eq 4
        expect(squads.where(available_unit: AvailableUnit.find_by(company: @company, unit: unit3)).size).to eq 1
      end

      it "updates the Company's AvailableUnits available value" do
        _, available_units = subject.update_company_squads(@company, squads_param)
        expect(available_units.size).to eq 3
        expect(AvailableUnit.find_by(company: @company, unit: unit1).available).to eq 3
        expect(AvailableUnit.find_by(company: @company, unit: unit2).available).to eq 1
        expect(AvailableUnit.find_by(company: @company, unit: unit3).available).to eq 0
      end

      it "raises a validation error when the Company does not belong to the Player" do
        player2 = create :player
        expect {
          CompanyService.new(player2).update_company_squads(@company, squads_param)
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Player #{player2.id} cannot delete Company #{@company.id}")
      end

      it "raises a validation error if a Squad id is given that's not part of the Company" do
        unknown_squad_id = 99999999
        invalid_squad_param = { squad_id: unknown_squad_id,
                                unit_id: unit1.id,
                                name: nil,
                                vet: 0,
                                tab: "core",
                                index: 0 }
        squads_param << invalid_squad_param
        expect {
          subject.update_company_squads(@company, squads_param)
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Given squad ids [#{unknown_squad_id}] that don't exist for the company #{@company.id}"
             )
      end

      it "raises a validation error if an invalid Unit id is given" do
        unknown_unit_id = 99999999
        invalid_squad_param = { squad_id: nil,
                                unit_id: unknown_unit_id,
                                name: nil,
                                vet: 0,
                                tab: "core",
                                index: 0 }
        squads_param << invalid_squad_param
        expect {
          subject.update_company_squads(@company, squads_param)
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Invalid unit id(s) given in company squad update: [#{unknown_unit_id}]"
             )
      end

      it "raises a validation error if an Unit id is given that doesn't match any AvailableUnit in the Company" do
        new_unit = create :unit
        invalid_squad_param = { squad_id: nil,
                                unit_id: new_unit.id,
                                name: nil,
                                vet: 0,
                                tab: "core",
                                index: 0 }
        squads_param << invalid_squad_param
        expect {
          subject.update_company_squads(@company, squads_param)
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Found unavailable unit ids [#{new_unit.id}] for the company #{@company.id}"
             )
      end

      context "when the resource quantities are small" do
        before do
          ruleset.update!(starting_man: 200, starting_mun: 200, starting_fuel: 200)
        end
        it "raises a validation error if the new squads' cost is greater in one or more resource than the ruleset's starting resources" do
          expect {
            subject.update_company_squads(@company.reload, squads_param)
          }.to raise_error(
                 CompanyService::CompanyUpdateValidationError,
                 "Invalid squad update, negative resource balance found: -600 manpower, -520 munitions, -120 fuel"
               )
        end
      end

      it "raises a validation error if a platoon has too little pop" do
        invalid_squad_param = { squad_id: nil,
                                unit_id: unit1.id,
                                name: nil,
                                vet: 0,
                                tab: "core",
                                index: 0 }
        expect {
          subject.update_company_squads(@company, [invalid_squad_param])
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Platoon at [core 0] has 4.0 pop, must be between 7 and 25, inclusive"
             )
      end

      it "raises a validation error if a platoon has too much pop" do
        invalid_squad_param = { squad_id: nil,
                                unit_id: unit3.id,
                                name: nil,
                                vet: 0,
                                tab: "armour",
                                index: 1 }
        squads_param << invalid_squad_param
        expect {
          subject.update_company_squads(@company, squads_param)
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Platoon at [armour 1] has 26.0 pop, must be between 7 and 25, inclusive"
             )
      end

      it "raises a validation error if there's insufficient availability to create a squad of a certain unit" do
        AvailableUnit.find_by(company: @company, unit: unit2).update!(available: 1)
        expect {
          subject.update_company_squads(@company.reload, squads_param)
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Insufficient availability to create squads for unit #{unit2.id} in company #{@company.id}: Existing count 0, payload count 4, available number 1"
             )
      end
    end

    context "when there are existing Squads in the Company" do
      let!(:unit4) { create :unit }
      let!(:restriction_unit4) { create :base_restriction_unit, unit: unit4, pop: 8, resupply: 1, resupply_max: 1, company_max: 2, restriction: restriction_doctrine }

      before do
        @company = subject.create_company(doctrine, name)
        @available_unit1 = @company.available_units.find_by(unit: unit1)
        @available_unit2 = @company.available_units.find_by(unit: unit2)
        @available_unit3 = @company.available_units.find_by(unit: unit3)
        @available_unit4 = @company.available_units.find_by(unit: unit4)

        squad1 = create :squad, company: @company, available_unit: @available_unit1, tab_category: "core", category_position: 0
        squad2 = create :squad, company: @company, available_unit: @available_unit2, tab_category: "core", category_position: 0
        squad3 = create :squad, company: @company, available_unit: @available_unit3, tab_category: "core", category_position: 0

        squad4 = create :squad, company: @company, available_unit: @available_unit2, tab_category: "assault", category_position: 1

        squad5 = create :squad, company: @company, available_unit: @available_unit1, tab_category: "infantry", category_position: 0
        squad6 = create :squad, company: @company, available_unit: @available_unit1, tab_category: "infantry", category_position: 0

        squad7 = create :squad, company: @company, available_unit: @available_unit2, tab_category: "infantry", category_position: 2

        squad8 = create :squad, company: @company, available_unit: @available_unit2, tab_category: "infantry", category_position: 3
        @available_unit1.update!(available: 3)
        @available_unit2.update!(available: 1)
        @available_unit3.update!(available: 0)
        # @available_unit4 has available 1

        # Unit1: Existing count: 3, Available: 3, Payload count: 3, Resupply max: 6
        # Unit2: Existing count: 4, Available: 1, Payload count: 3, resupply max: 5
        # Unit3: Existing count: 1, Available: 0, Payload count: 0, resupply_max: 1
        # Unit4: Existing count: 0, Available: 1, Payload count: 1, resupply_max: 1

        @squads_param = [
          {
            squad_id: squad1.id,
            unit_id: unit1.id,
            name: nil,
            vet: 0,
            tab: "core",
            index: 0
          },
          {
            squad_id: squad2.id,
            unit_id: unit2.id,
            name: nil,
            vet: 0,
            tab: "core",
            index: 0
          },
          {
            squad_id: nil,
            unit_id: unit4.id,
            name: nil,
            vet: 0,
            tab: "core",
            index: 0
          },
          {
            squad_id: squad5.id,
            unit_id: unit1.id,
            name: nil,
            vet: 0,
            tab: "infantry",
            index: 0
          },
          {
            squad_id: squad6.id,
            unit_id: unit1.id,
            name: nil,
            vet: 0,
            tab: "infantry",
            index: 0
          },
          {
            squad_id: squad7.id,
            unit_id: unit2.id,
            name: nil,
            vet: 0,
            tab: "infantry",
            index: 2
          },
          {
            squad_id: squad8.id,
            unit_id: unit2.id,
            name: nil,
            vet: 0,
            tab: "infantry",
            index: 3
          }
        ]
      end

      it "creates all input Squads for the Company" do
        squads, _ = subject.update_company_squads(@company, @squads_param)
        expect(squads.size).to eq @squads_param.size

        expect(squads.where(available_unit: AvailableUnit.find_by(company: @company, unit: unit1)).size).to eq 3
        expect(squads.where(available_unit: AvailableUnit.find_by(company: @company, unit: unit2)).size).to eq 3
        expect(squads.where(available_unit: AvailableUnit.find_by(company: @company, unit: unit3)).size).to eq 0
        expect(squads.where(available_unit: AvailableUnit.find_by(company: @company, unit: unit4)).size).to eq 1
      end

      it "updates the Company's AvailableUnits available value" do
        _, available_units = subject.update_company_squads(@company, @squads_param)
        expect(available_units.size).to eq 4
        expect(AvailableUnit.find_by(company: @company, unit: unit1).available).to eq 3
        expect(AvailableUnit.find_by(company: @company, unit: unit2).available).to eq 2
        expect(AvailableUnit.find_by(company: @company, unit: unit3).available).to eq 1
        expect(AvailableUnit.find_by(company: @company, unit: unit4).available).to eq 0
      end

      it "raises a validation error if a Squad id is given that's not part of the Company" do
        unknown_squad_id = 99999999
        invalid_squad_param = { squad_id: unknown_squad_id,
                                unit_id: unit1.id,
                                name: nil,
                                vet: 0,
                                tab: "core",
                                index: 0 }
        @squads_param << invalid_squad_param
        expect {
          subject.update_company_squads(@company, @squads_param)
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Given squad ids [#{unknown_squad_id}] that don't exist for the company #{@company.id}"
             )
      end

      it "raises a validation error if an invalid Unit id is given" do
        unknown_unit_id = 99999999
        invalid_squad_param = { squad_id: nil,
                                unit_id: unknown_unit_id,
                                name: nil,
                                vet: 0,
                                tab: "core",
                                index: 0 }
        @squads_param << invalid_squad_param
        expect {
          subject.update_company_squads(@company, @squads_param)
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Invalid unit id(s) given in company squad update: [#{unknown_unit_id}]"
             )
      end

      it "raises a validation error if an Unit id is given that doesn't match any AvailableUnit in the Company" do
        new_unit = create :unit
        invalid_squad_param = { squad_id: nil,
                                unit_id: new_unit.id,
                                name: nil,
                                vet: 0,
                                tab: "core",
                                index: 0 }
        @squads_param << invalid_squad_param
        expect {
          subject.update_company_squads(@company, @squads_param)
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Found unavailable unit ids [#{new_unit.id}] for the company #{@company.id}"
             )
      end

      context "when the resource quantities are small" do
        before do
          ruleset.update!(starting_man: 200, starting_mun: 200, starting_fuel: 200)
        end
        it "raises a validation error if the new squads' cost is greater in one or more resource than the ruleset's starting resources" do
          expect {
            subject.update_company_squads(@company.reload, @squads_param)
          }.to raise_error(
                 CompanyService::CompanyUpdateValidationError,
                 "Invalid squad update, negative resource balance found: -500 manpower, -430 munitions, -80 fuel"
               )
        end
      end

      it "raises a validation error if a platoon has too little pop" do
        invalid_squad_param = { squad_id: nil,
                                unit_id: unit1.id,
                                name: nil,
                                vet: 0,
                                tab: "core",
                                index: 0 }
        expect {
          subject.update_company_squads(@company, [invalid_squad_param])
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Platoon at [core 0] has 4.0 pop, must be between 7 and 25, inclusive"
             )
      end

      it "raises a validation error if a platoon has too much pop" do
        invalid_squad_param = { squad_id: nil,
                                unit_id: unit3.id,
                                name: nil,
                                vet: 0,
                                tab: "core",
                                index: 0 }
        @squads_param << invalid_squad_param
        expect {
          subject.update_company_squads(@company, @squads_param)
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Platoon at [core 0] has 32.0 pop, must be between 7 and 25, inclusive"
             )
      end

      it "raises a validation error if there's insufficient availability to create a squad of a certain unit" do
        AvailableUnit.find_by(company: @company, unit: unit4).update!(available: 0)
        expect {
          subject.update_company_squads(@company.reload, @squads_param)
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Insufficient availability to create squads for unit #{unit4.id} in company #{@company.id}: Existing count 0, payload count 1, available number 0"
             )
      end
    end
  end

  context "#delete_company" do
    before do
      @company = subject.create_company(doctrine, name)
      @available_unit1 = @company.available_units.find_by(unit: unit1)
      @available_unit2 = @company.available_units.find_by(unit: unit2)
      @available_unit3 = @company.available_units.find_by(unit: unit3)

      create :squad, company: @company, available_unit: @available_unit1, tab_category: "core", category_position: 0
      create :squad, company: @company, available_unit: @available_unit2, tab_category: "core", category_position: 0
      create :squad, company: @company, available_unit: @available_unit3, tab_category: "core", category_position: 3
    end

    it "destroys the Company" do
      subject.delete_company(@company)
      expect { @company.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
    it "destroys the Company's AvailableUnits" do
      company_id = @company.id
      subject.delete_company(@company)
      expect(AvailableUnit.where(company_id: company_id).size).to eq 0
    end
    it "destroys the Company's Squads" do
      company_id = @company.id
      subject.delete_company(@company)
      expect(Squad.where(company_id: company_id).size).to eq 0
    end
  end

  context "#can_create_company" do
    it "can create when the player does not have the max number of companies for that side" do
      create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset
      expect(subject.send(:can_create_company, doctrine)).to be true
    end

    it "cannot create when the player has the max number of companies for that side" do
      create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset
      create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset
      expect(subject.send(:can_create_company, doctrine)).to be false
    end
  end

  context "#can_update_company" do
    it "returns true when the player is associated with the company" do
      company = create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset
      expect(subject.send(:can_update_company, company, false)).to be true
    end
    it "returns false when the player is not associated with the company" do
      player2 = create :player
      company = create :company, player: player2, faction: faction, doctrine: doctrine, ruleset: ruleset
      expect(subject.send(:can_update_company, company, false)).to be false
    end
    it "returns true when the player is not associated with the company but the override is true" do
      player2 = create :player
      company = create :company, player: player2, faction: faction, doctrine: doctrine, ruleset: ruleset
      expect(subject.send(:can_update_company, company, true)).to be true
    end
  end

  context "#validate_incoming_squad_ids" do
    it "passes when the incoming squad ids are not duplicated and are a subset of the existing squad ids" do
      incoming_ids = [1, 2, 3, 4]
      existing_ids = [1, 2, 3, 4, 5, 6]
      expect { subject.send(:validate_incoming_squad_ids, incoming_ids, existing_ids, 1) }.
        not_to raise_error
    end
    it "fails when the incoming squad ids have duplicates" do
      incoming_ids = [1, 2, 2, 3, 4, 4]
      existing_ids = []
      expect { subject.send(:validate_incoming_squad_ids, incoming_ids, existing_ids, 1) }.
        to raise_error(CompanyService::CompanyUpdateValidationError, "Duplicate squad ids found in payload squad ids: [2, 4]")
    end
    it "fails when the incoming squad ids are not duplicated but are not a subset of the existing squad ids" do
      incoming_ids = [1, 2, 3, 4, 7, 8]
      existing_ids = [1, 2, 3, 4, 5, 6]
      expect { subject.send(:validate_incoming_squad_ids, incoming_ids, existing_ids, 1) }.
        to raise_error(CompanyService::CompanyUpdateValidationError, "Given squad ids [7, 8] that don't exist for the company 1")
    end
  end

  context "#validate_squad_units_exist" do
    it "passes when the unique units match unique units" do
      uniq_unit_ids = [1, 2, 3]
      uniq_units_by_id = { 1 => Unit.new, 2 => Unit.new, 3 => Unit.new }
      expect { subject.send(:validate_squad_units_exist, uniq_unit_ids, uniq_units_by_id) }.
        not_to raise_error
    end
    it "fails when the unique units don't match unique units" do
      uniq_unit_ids = [1, 2, 3]
      uniq_units_by_id = { 1 => Unit.new, 2 => Unit.new }
      expect { subject.send(:validate_squad_units_exist, uniq_unit_ids, uniq_units_by_id) }.
        to raise_error(CompanyService::CompanyUpdateValidationError, "Invalid unit id(s) given in company squad update: [3]")
    end
  end

  context "#validate_squad_units_available" do
    let!(:company) { create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset }
    let!(:available_unit1) { create :available_unit, company: company, unit: unit1 }
    let!(:available_unit2) { create :available_unit, company: company, unit: unit2 }

    it "passes when all unit ids match an available unit for the company" do
      uniq_unit_ids = [unit1.id, unit2.id]
      available_units = [available_unit1, available_unit2]
      expect { subject.send(:validate_squad_units_available, uniq_unit_ids, available_units, company.id) }.
        not_to raise_error
    end

    it "fails when not unit ids match an available unit for the company" do
      uniq_unit_ids = [unit1.id, unit2.id, unit3.id]
      available_units = [available_unit1, available_unit2]
      expect { subject.send(:validate_squad_units_available, uniq_unit_ids, available_units, company.id) }.
        to raise_error(CompanyService::CompanyUpdateValidationError, "Found unavailable unit ids [#{unit3.id}] for the company #{company.id}")
    end
  end

  context "#build_empty_tab_index_pop" do
    it "builds a hash with tab categories as keys" do
      result = subject.send(:build_empty_tab_index_pop)
      expect(result.keys).to match_array(Squad.tab_categories.values)
    end
    it "builds a hash where every value is an array of 8 zeros" do
      result = subject.send(:build_empty_tab_index_pop)
      expect(result.values.select { |e| e != Array.new(8, 0) }.size).to eq 0
    end
  end

  context "#calculate_squad_resources" do
    let(:company) { create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset }
    let(:available_unit1) { create :available_unit, company: company, unit: unit1, man: 100, mun: 0, fuel: 40, pop: 2 }
    let(:available_unit2) { create :available_unit, company: company, unit: unit2, man: 400, mun: 130, fuel: 0, pop: 8 }
    let(:squads) { [{ unit_id: unit1.id, tab: "core", index: 0 }, { unit_id: unit1.id, tab: "core", index: 0 },
                    { unit_id: unit2.id, tab: "infantry", index: 1 }, { unit_id: unit2.id, tab: "infantry", index: 2 }] }
    let(:available_units_by_unit_id) { { unit1.id => available_unit1, unit2.id => available_unit2 } }
    let(:platoon_pop_by_tab_and_index) { { "core": [0, 0, 0], "infantry": [0, 0, 0] }.with_indifferent_access }

    it "returns the correct resources" do
      man, mun, fuel, pop = subject.send(:calculate_squad_resources, squads, available_units_by_unit_id, platoon_pop_by_tab_and_index)
      expect(man).to eq(1000)
      expect(mun).to eq(260)
      expect(fuel).to eq(80)
      expect(pop).to eq(20)
    end

    it "sets the correct platoon pop" do
      subject.send(:calculate_squad_resources, squads, available_units_by_unit_id, platoon_pop_by_tab_and_index)
      expect(platoon_pop_by_tab_and_index["core"].size).to eq 3
      expect(platoon_pop_by_tab_and_index["core"][0]).to eq 4
      expect(platoon_pop_by_tab_and_index["core"][1]).to eq 0
      expect(platoon_pop_by_tab_and_index["core"][2]).to eq 0
      expect(platoon_pop_by_tab_and_index["infantry"].size).to eq 3
      expect(platoon_pop_by_tab_and_index["infantry"][0]).to eq 0
      expect(platoon_pop_by_tab_and_index["infantry"][1]).to eq 8
      expect(platoon_pop_by_tab_and_index["infantry"][2]).to eq 8
    end
  end

  context "#get_total_available_resources" do
    let(:starting_man) { 5000 }
    let(:starting_mun) { 2000 }
    let(:starting_fuel) { 1400 }
    let(:ruleset) { create :ruleset, starting_man: starting_man, starting_mun: starting_mun, starting_fuel: starting_fuel }
    it "returns the correct resources" do
      man, mun, fuel = subject.send(:get_total_available_resources, ruleset)
      expect(man).to eq starting_man
      expect(mun).to eq starting_mun
      expect(fuel).to eq starting_fuel
    end
  end

  context "#calculate_remaining_resources" do
    let(:ruleset) { create :ruleset, starting_man: 5000, starting_mun: 2000, starting_fuel: 1400 }

    it "returns resources remaining when the remaining resources are > 0" do
      man, mun, fuel = subject.send(:calculate_remaining_resources, ruleset, 4500, 1200, 1400)
      expect(man).to eq 500
      expect(mun).to eq 800
      expect(fuel).to eq 0
    end

    it "raises an error when one or more resource remaining is less than 0" do
      expect { subject.send(:calculate_remaining_resources, ruleset, 5500, 1200, 1400) }.
        to raise_error(CompanyService::CompanyUpdateValidationError,
                       "Invalid squad update, negative resource balance found: -500 manpower, 800 munitions, 0 fuel")
    end
  end

  context "#validate_platoon_pop" do
    it "passes when all platoons have valid pop" do
      platoon_pop_by_tab_and_index = { "core": [0, 10, 0], "infantry": [12, 12, 8] }
      expect { subject.send(:validate_platoon_pop, platoon_pop_by_tab_and_index) }.
        not_to raise_error
    end

    it "fails when a platoon has pop greater than zero but less than the minimum" do
      platoon_pop_by_tab_and_index = { "core": [1, 10, 0], "infantry": [12, 12, 8] }
      expect { subject.send(:validate_platoon_pop, platoon_pop_by_tab_and_index) }.
        to raise_error(CompanyService::CompanyUpdateValidationError,
                       "Platoon at [core 0] has 1 pop, must be between 7 and 25, inclusive")
    end

    it "fails when a platoon has pop greater than the maximum" do
      platoon_pop_by_tab_and_index = { "core": [0, 10, 0], "infantry": [12, 27, 8] }
      expect { subject.send(:validate_platoon_pop, platoon_pop_by_tab_and_index) }.
        to raise_error(CompanyService::CompanyUpdateValidationError,
                       "Platoon at [infantry 1] has 27 pop, must be between 7 and 25, inclusive")
    end
  end

  context "#build_available_unit_deltas" do
    let(:company) { create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset }
    let(:available_unit1) { create :available_unit, company: company, unit: unit1, available: 1 }
    let(:available_unit2) { create :available_unit, company: company, unit: unit2, available: 1 }
    let(:available_unit3) { create :available_unit, company: company, unit: unit3, available: 0 }
    let(:squad1) { create :squad, company: company, available_unit: available_unit1, tab_category: "core", category_position: 0 }
    let(:squad2) { create :squad, company: company, available_unit: available_unit1, tab_category: "core", category_position: 0 }
    let(:squad3) { create :squad, company: company, available_unit: available_unit2, tab_category: "infantry", category_position: 0 }
    let(:squad4) { create :squad, company: company, available_unit: available_unit3, tab_category: "infantry", category_position: 1 }
    let(:existing_squads_by_unit_id) { { unit1.id => [squad1, squad2], unit2.id => [squad3], unit3.id => [squad4] } }
    let(:payload_squad_by_unit_id) { { unit1.id => [{ unit_id: unit1.id, tab: "core", index: 0 }, { unit_id: unit1.id, tab: "core", index: 0 }],
                                       unit2.id => [{ unit_id: unit2.id, tab: "infantry", index: 1 }, { unit_id: unit2.id, tab: "infantry", index: 2 }] } }
    let(:available_units_by_unit_id) { { unit1.id => available_unit1, unit2.id => available_unit2, unit3.id => available_unit3 } }

    it "builds the correct availability changes hash for only units in the payload squads" do
      available_changes = subject.send(:build_available_unit_deltas, company, payload_squad_by_unit_id, existing_squads_by_unit_id, available_units_by_unit_id)
      expect(available_changes.size).to eq 2
      expect(available_changes.keys).to match_array([unit1.id, unit2.id])
      expect(available_changes[unit1.id]).to eq 0
      expect(available_changes[unit2.id]).to eq -1
    end

    context "when there is insufficient availability for a unit" do
      let(:available_unit2) { create :available_unit, company: company, unit: unit2, available: 0 }

      it "raises an error" do
        expect { subject.send(:build_available_unit_deltas, company, payload_squad_by_unit_id, existing_squads_by_unit_id, available_units_by_unit_id) }.
          to raise_error(CompanyService::CompanyUpdateValidationError,
                         "Insufficient availability to create squads for unit #{unit2.id} in company #{company.id}: Existing count 1, payload count 2, available number 0")
      end
    end
  end

  context "#add_existing_squads_to_remove" do
    let(:company) { create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset }
    let(:available_unit1) { create :available_unit, company: company, unit: unit1, available: 1 }
    let(:available_unit2) { create :available_unit, company: company, unit: unit2, available: 1 }
    let(:available_unit3) { create :available_unit, company: company, unit: unit3, available: 0 }
    let(:squad1) { create :squad, company: company, available_unit: available_unit1, tab_category: "core", category_position: 0 }
    let(:squad2) { create :squad, company: company, available_unit: available_unit1, tab_category: "core", category_position: 0 }
    let(:squad3) { create :squad, company: company, available_unit: available_unit2, tab_category: "infantry", category_position: 0 }
    let(:squad4) { create :squad, company: company, available_unit: available_unit3, tab_category: "infantry", category_position: 1 }
    let(:existing_squads_by_unit_id) { { unit1.id => [squad1, squad2], unit2.id => [squad3], unit3.id => [squad4] } }
    let(:available_changes) { { unit1.id => -1, unit2.id => 0 } }

    it "adds the existing squad to remove availability to available changes" do
      subject.send(:add_existing_squads_to_remove, existing_squads_by_unit_id, available_changes)
      expect(available_changes.size).to eq 3
      expect(available_changes.keys).to match_array([unit1.id, unit2.id, unit3.id])
      expect(available_changes[unit3.id]).to eq 1
    end
  end
end
