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
               "Invalid squad update. Given squad ids [#{unknown_squad_id}] that don't exist for the company #{@company.id}"
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
               "Cannot create squads. Invalid unit id(s) given: [#{unknown_unit_id}]"
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
               "Cannot create squads, found unavailable unit ids [#{new_unit.id}]"
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
               "Invalid squad update. Platoon at [core 0] has 4.0 pop, must be between [7,25] inclusive"
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
               "Invalid squad update. Platoon at [armour 1] has 26.0 pop, must be between [7,25] inclusive"
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
               "Invalid squad update. Given squad ids [#{unknown_squad_id}] that don't exist for the company #{@company.id}"
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
               "Cannot create squads. Invalid unit id(s) given: [#{unknown_unit_id}]"
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
               "Cannot create squads, found unavailable unit ids [#{new_unit.id}]"
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
               "Invalid squad update. Platoon at [core 0] has 4.0 pop, must be between [7,25] inclusive"
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
               "Invalid squad update. Platoon at [core 0] has 32.0 pop, must be between [7,25] inclusive"
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
end
