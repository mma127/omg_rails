require "rails_helper"

RSpec.describe CompanyService do
  let!(:player) { create :player }
  subject(:instance) { described_class.new(player) }

  let(:name) { "My new company" }
  let!(:ruleset) { create :ruleset }
  let(:faction) { create :faction }
  let(:doctrine) { create :doctrine, faction: faction }
  let!(:restriction_faction) { create :restriction, faction: faction, doctrine: nil, unlock: nil }
  let!(:restriction_doctrine) { create :restriction, faction: nil, doctrine: doctrine, unlock: nil }
  let(:unit1) { create :unit }
  let(:unit2) { create :unit }
  let(:unit3) { create :unit }
  let!(:restriction_unit1) { create :enabled_unit, unit: unit1, pop: 4, resupply: 4, resupply_max: 6, company_max: 10, restriction: restriction_faction, ruleset: ruleset }
  let!(:restriction_unit2) { create :enabled_unit, unit: unit2, pop: 7, resupply: 2, resupply_max: 5, company_max: 5, restriction: restriction_faction, ruleset: ruleset }
  let!(:restriction_unit3) { create :enabled_unit, unit: unit3, pop: 13, resupply: 1, resupply_max: 1, company_max: 2, restriction: restriction_doctrine, ruleset: ruleset }
  let(:offmap1) { create :offmap }
  let(:offmap2) { create :offmap, unlimited_uses: false }
  let!(:restriction_offmap1) { create :restriction_offmap, ruleset: ruleset, restriction: restriction_faction, offmap: offmap1, mun: 100, max: 1 }
  let!(:restriction_offmap2) { create :restriction_offmap, ruleset: ruleset, restriction: restriction_doctrine, offmap: offmap2, mun: 120, max: 3 }
  let(:upgrade1) { create :upgrade }
  let(:upgrade2) { create :upgrade }
  let(:upgrade3) { create :upgrade }
  let!(:enabled_upgrade1) { create :enabled_upgrade, upgrade: upgrade1, pop: 0, man: 0, mun: 35, fuel: 0, uses: 2, restriction: restriction_faction, ruleset: ruleset }
  let!(:enabled_upgrade2) { create :enabled_upgrade, upgrade: upgrade2, pop: 2, man: 100, mun: 20, fuel: 0, uses: 0, restriction: restriction_faction, ruleset: ruleset }
  let!(:enabled_upgrade3) { create :enabled_upgrade, upgrade: upgrade3, pop: 0, man: 0, mun: 0, fuel: 50, uses: 0, restriction: restriction_doctrine, ruleset: ruleset }

  before do
    create :restriction_upgrade_unit, restriction_upgrade: enabled_upgrade1, unit: unit1
    create :restriction_upgrade_unit, restriction_upgrade: enabled_upgrade1, unit: unit2
    create :restriction_upgrade_unit, restriction_upgrade: enabled_upgrade2, unit: unit2
    create :restriction_upgrade_unit, restriction_upgrade: enabled_upgrade3, unit: unit3
  end

  describe "#create_company" do
    subject { instance.create_company(doctrine, name) }
    it "creates the Company with valid params" do
      company = subject

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
      company = subject
      expect(company.available_units.size).to eq 3
    end

    it "builds the Company's AvailableOffmaps" do
      company = subject
      expect(company.available_offmaps.size).to eq 2
      expect(company.available_offmaps.first.offmap).to eq offmap1
      expect(company.available_offmaps.first.available).to eq restriction_offmap1.max
      expect(company.available_offmaps.second.offmap).to eq offmap2
      expect(company.available_offmaps.second.available).to eq restriction_offmap2.max
    end

    it "builds the Company's AvailableUpgrades" do
      company = subject
      expect(company.available_upgrades.count).to eq 4
      expect(company.available_upgrades.find_by(upgrade: upgrade1, unit: unit1)).not_to be nil
      expect(company.available_upgrades.find_by(upgrade: upgrade1, unit: unit2)).not_to be nil
      expect(company.available_upgrades.find_by(upgrade: upgrade2, unit: unit2)).not_to be nil
      expect(company.available_upgrades.find_by(upgrade: upgrade3, unit: unit3)).not_to be nil
    end

    it "raises a validation error when the Player has too many Companies of that side" do
      create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset
      create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset
      expect { subject }
        .to raise_error(
              CompanyService::CompanyCreationValidationError,
              "Player #{player.id} has too many #{faction.side} companies, cannot create another one.")
    end
  end

  describe "#update_company_squads" do
    let!(:offmaps_param) { [] }
    let!(:squad_upgrades_param) { [] }

    subject { instance.update_company_squads(company, squads_param, offmaps_param, squad_upgrades_param) }

    context "when the Company is empty" do
      let!(:company) { instance.create_company(doctrine, name) }
      let!(:available_unit_1) { company.available_units.find_by(unit_id: unit1.id) }
      let!(:available_unit_2) { company.available_units.find_by(unit_id: unit2.id) }
      let!(:available_unit_3) { company.available_units.find_by(unit_id: unit3.id) }
      let!(:available_offmap_1) { company.available_offmaps.find_by(offmap: offmap1) }
      let!(:available_offmap_2) { company.available_offmaps.find_by(offmap: offmap2) }
      let!(:available_upgrade_1_1) { company.available_upgrades.find_by(upgrade: upgrade1, unit: unit1) }
      let!(:available_upgrade_1_2) { company.available_upgrades.find_by(upgrade: upgrade1, unit: unit2) }
      let!(:available_upgrade_2) { company.available_upgrades.find_by(upgrade: upgrade2) }
      let!(:available_upgrade_3) { company.available_upgrades.find_by(upgrade: upgrade3) }
      let!(:squads_param) do
        [{
           squad_id: nil,
           unit_id: unit1.id,
           available_unit_id: available_unit_1.id,
           name: nil,
           vet: 0,
           tab: "core",
           index: 0,
           uuid: "1"
         }, {
           squad_id: nil,
           unit_id: unit2.id,
           available_unit_id: available_unit_2.id,
           name: nil,
           vet: 0,
           tab: "core",
           index: 0,
           uuid: '2'
         }, {
           squad_id: nil,
           unit_id: unit2.id,
           available_unit_id: available_unit_2.id,
           name: nil,
           vet: 0,
           tab: "core",
           index: 1,
           uuid: "3"
         }, {
           squad_id: nil,
           unit_id: unit2.id,
           available_unit_id: available_unit_2.id,
           name: nil,
           vet: 0,
           tab: "infantry",
           index: 0,
           uuid: "4"
         }, {
           squad_id: nil,
           unit_id: unit2.id,
           available_unit_id: available_unit_2.id,
           name: nil,
           vet: 0,
           tab: "infantry",
           index: 1,
           uuid: "5"
         }, {
           squad_id: nil,
           unit_id: unit1.id,
           available_unit_id: available_unit_1.id,
           name: nil,
           vet: 0,
           tab: "infantry",
           index: 2,
           uuid: "6"
         }, {
           squad_id: nil,
           unit_id: unit1.id,
           name: nil,
           available_unit_id: available_unit_1.id,
           vet: 0,
           tab: "infantry",
           index: 2,
           uuid: "7"
         }, {
           squad_id: nil,
           unit_id: unit3.id,
           available_unit_id: available_unit_3.id,
           name: nil,
           vet: 0,
           tab: "armour",
           index: 1,
           uuid: "8"
         }]
      end
      let!(:offmaps_param) do
        [{
           company_offmap_id: nil,
           available_offmap_id: available_offmap_1.id
         }, {
           company_offmap_id: nil,
           available_offmap_id: available_offmap_2.id
         }, {
           company_offmap_id: nil,
           available_offmap_id: available_offmap_2.id
         }]
      end
      let!(:squad_upgrades_param) do
        [{
           squad_upgrade_id: nil,
           available_upgrade_id: available_upgrade_1_1.id,
           squad_id: nil,
           squad_uuid: '1'
         }, {
           squad_upgrade_id: nil,
           available_upgrade_id: available_upgrade_1_2.id,
           squad_id: nil,
           squad_uuid: '2'
         }, {
           squad_upgrade_id: nil,
           available_upgrade_id: available_upgrade_1_2.id,
           squad_id: nil,
           squad_uuid: '3'
         }, {
           squad_upgrade_id: nil,
           available_upgrade_id: available_upgrade_2.id,
           squad_id: nil,
           squad_uuid: '3'
         }, {
           squad_upgrade_id: nil,
           available_upgrade_id: available_upgrade_3.id,
           squad_id: nil,
           squad_uuid: '8'
         }]
      end

      it "creates all input Squads for the Company" do
        subject
        squads = company.reload.squads
        expect(squads.size).to eq squads_param.size

        expect(squads.where(available_unit: available_unit_1).size).to eq 3
        expect(squads.where(available_unit: available_unit_2).size).to eq 4
        expect(squads.where(available_unit: available_unit_3).size).to eq 1
      end

      it "updates the Company's AvailableUnits available value" do
        subject
        available_units = company.reload.available_units
        expect(available_units.size).to eq 3
        expect(available_unit_1.reload.available).to eq 3
        expect(available_unit_2.reload.available).to eq 1
        expect(available_unit_3.reload.available).to eq 0
      end

      it "creates all input CompanyOffmaps for the Company" do
        subject
        company_offmaps = company.reload.company_offmaps
        expect(company_offmaps.size).to eq offmaps_param.size
        expect(company_offmaps.where(available_offmap: available_offmap_1).size).to eq 1
        expect(company_offmaps.where(available_offmap: available_offmap_2).size).to eq 2
      end

      it "updates the Company's AvailableOffmaps available value" do
        subject
        available_offmaps = company.reload.available_offmaps
        expect(available_offmaps.size).to eq 2
        expect(available_offmaps.find_by(offmap: offmap1).available).to eq 0
        expect(available_offmaps.find_by(offmap: offmap2).available).to eq 1
      end

      it "creates all input SquadUpgrades for the Company" do
        subject
        squad_upgrades = company.reload.squad_upgrades
        expect(squad_upgrades.size).to eq squad_upgrades_param.size
        expect(squad_upgrades.where(available_upgrade: available_upgrade_1_1).count).to eq 1
        expect(squad_upgrades.where(available_upgrade: available_upgrade_1_2).count).to eq 2
        expect(squad_upgrades.where(available_upgrade: available_upgrade_2).count).to eq 1
        expect(squad_upgrades.where(available_upgrade: available_upgrade_3).count).to eq 1
      end

      it "sets the correct squad pop if there is a squadUpgrade with nonzero pop" do
        subject
        squad_upgrades = company.reload.squad_upgrades.where(available_upgrade: available_upgrade_2)
        expect(squad_upgrades.size).to eq 1

        squad = squad_upgrades.first.squad
        expected_pop = squad.available_unit.pop + available_upgrade_2.pop
        expect(squad.pop).to eq expected_pop
      end

      it "sets the correct squad pop if there are no squad upgrades with nonzero pop for the squad" do
        subject
        squad_upgrades = company.reload.squad_upgrades.where(available_upgrade: available_upgrade_2)
        expect(squad_upgrades.size).to eq 1
        pop_squad = squad_upgrades.first.squad
        squads = company.squads.where.not(id: pop_squad.id)
        squads.each do |squad|
          expected_pop = squad.available_unit.pop
          expect(squad.pop).to eq expected_pop
        end
      end

      it "raises a validation error when the Company does not belong to the Player" do
        player2 = create :player
        expect {
          CompanyService.new(player2).update_company_squads(company, squads_param, offmaps_param, squad_upgrades_param)
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Player #{player2.id} cannot delete Company #{company.id}")
      end

      it "raises a validation error if a Squad id is given that's not part of the Company" do
        unknown_squad_id = 99999999
        invalid_squad_param = { squad_id: unknown_squad_id,
                                unit_id: unit1.id,
                                available_unit_id: available_unit_1.id,
                                name: nil,
                                vet: 0,
                                tab: "core",
                                index: 0 }
        squads_param << invalid_squad_param
        expect { subject }
          .to raise_error(
                CompanyService::CompanyUpdateValidationError,
                "Given squad ids [#{unknown_squad_id}] that don't exist for the company #{company.id}"
              )
      end

      it "raises a validation error if a CompanyOffmap id is given that's not part of the Company" do
        unknown_company_offmap_id = 9999999
        invalid_company_offmap_param = { company_offmap_id: unknown_company_offmap_id, available_offmap_id: available_offmap_1.id }
        offmaps_param << invalid_company_offmap_param
        expect { subject }
          .to raise_error(
                CompanyService::CompanyUpdateValidationError,
                "Given company offmap ids [#{unknown_company_offmap_id}] that don't exist for the company #{company.id}")
      end

      it "raises a validation error if a SquadUpgrade id is given that's not part of the Company" do
        unknown_squad_upgrade_id = 9999999
        invalid_squad_upgrade_param = { squad_upgrade_id: unknown_squad_upgrade_id, available_upgrade_id: available_upgrade_1_1.id }
        squad_upgrades_param << invalid_squad_upgrade_param
        expect { subject }
          .to raise_error(
                CompanyService::CompanyUpdateValidationError,
                "Given squad upgrade ids [#{unknown_squad_upgrade_id}] that don't exist for the company #{company.id}")
      end

      it "raises a validation error if an invalid Unit id is given" do
        unknown_unit_id = 99999999
        invalid_squad_param = { squad_id: nil,
                                unit_id: unknown_unit_id,
                                available_unit_id: unknown_unit_id,
                                name: nil,
                                vet: 0,
                                tab: "core",
                                index: 0 }
        squads_param << invalid_squad_param
        expect {
          instance.update_company_squads(company, squads_param, offmaps_param, squad_upgrades_param)
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Invalid unit id(s) given in company squad update: [#{unknown_unit_id}]"
             )
      end

      it "raises a validation error if an Unit id is given that doesn't match any AvailableUnit in the Company" do
        new_unit = create :unit
        new_available_unit = create :available_unit, unit: new_unit
        invalid_squad_param = { squad_id: nil,
                                unit_id: new_unit.id,
                                available_unit_id: new_available_unit.id,
                                name: nil,
                                vet: 0,
                                tab: "core",
                                index: 0 }
        squads_param << invalid_squad_param
        expect {
          instance.update_company_squads(company, squads_param, offmaps_param, squad_upgrades_param)
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Invalid available_unit_id(s) given in company #{company.id} squad update: [#{new_available_unit.id}]"
             )
      end

      it "raises a validation error if an AvailableOffmap id is given that doesn't match any AvailableOffmap in the Company" do
        new_offmap = create :offmap
        new_available_offmap = create :available_offmap, offmap: new_offmap # company will not be the same
        invalid_offmap_param = { company_offmap_id: nil, available_offmap_id: new_available_offmap.id }
        offmaps_param << invalid_offmap_param
        expect {
          subject
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Invalid available_offmap_id(s) given in company #{company.id} squad update: [#{new_available_offmap.id}]"
             )
      end

      it "raises a validation error if an AvailableUpgrade id is given that doesn't match any AvailableUpgrade in the Company" do
        new_upgrade = create :upgrade
        new_available_upgrade = create :available_upgrade, upgrade: new_upgrade # company will not be the same
        invalid_upgrade_param = { squad_upgrade_id: nil, available_upgrade_id: new_available_upgrade.id }
        squad_upgrades_param << invalid_upgrade_param
        expect {
          subject
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Invalid available_upgrade_id(s) given in company #{company.id} squad update: [#{new_available_upgrade.id}]"
             )
      end

      it "raises a validation error if a squad_upgrade's squad_uuid does not match any squad's uuid in the Company" do
        unknown_uuid = '43989534'
        invalid_upgrade_param = { squad_upgrade_id: nil, available_upgrade_id: available_upgrade_1_1.id, squad_id: nil, squad_uuid: unknown_uuid }
        squad_upgrades_param << invalid_upgrade_param
        expected_error = { unknown_uuid => [invalid_upgrade_param] }
        expect {
          subject
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Found squad upgrades not associated with a squad uuid: #{expected_error}"
             )
      end

      context "when an upgrade has a max" do
        let!(:enabled_upgrade1) { create :enabled_upgrade, upgrade: upgrade1, pop: 0, man: 0, mun: 35, fuel: 0, uses: 2, max: 1, restriction: restriction_faction, ruleset: ruleset }
        let!(:squad_upgrades_param) do
          [{
             squad_upgrade_id: nil,
             available_upgrade_id: available_upgrade_1_1.id,
             squad_id: nil,
             squad_uuid: '1'
           }, {
             squad_upgrade_id: nil,
             available_upgrade_id: available_upgrade_1_1.id,
             squad_id: nil,
             squad_uuid: '1'
           }]
        end

        it "raises a validation if squad exceeds the max number of that upgrade" do
          expect { subject }
            .to raise_error(
                  CompanyService::CompanyUpdateValidationError,
                  "Found 2 uses of available upgrade #{available_upgrade_1_1.id} with max 1, for company #{company.id} update and squad available unit id #{available_unit_1.id}" )
        end
      end

      context "when an upgrade has slots" do
        let(:unit1) { create :unit, upgrade_slots: 1 }
        let!(:enabled_upgrade1) { create :enabled_upgrade, upgrade: upgrade1, pop: 0, man: 0, mun: 35, fuel: 0, uses: 2, restriction: restriction_faction, ruleset: ruleset, upgrade_slots: 1 }
        let!(:squad_upgrades_param) do
          [{
             squad_upgrade_id: nil,
             available_upgrade_id: available_upgrade_1_1.id,
             squad_id: nil,
             squad_uuid: '1'
           }, {
             squad_upgrade_id: nil,
             available_upgrade_id: available_upgrade_1_1.id,
             squad_id: nil,
             squad_uuid: '1'
           }]
        end

        it "raises a validation if squad exceeds the upgrade slot limit of that upgrade" do
          expect { subject }
            .to raise_error(
                  CompanyService::CompanyUpdateValidationError,
                  "Found 2 upgrade slots used for unit #{unit1.id} with #{unit1.upgrade_slots} upgrade slots, for company #{company.id} update and squad available unit id #{available_unit_1.id}" )
        end
      end

      context "when an upgrade has unitwide slots" do
        let(:unit1) { create :unit, unitwide_upgrade_slots: 1 }
        let!(:enabled_upgrade1) { create :enabled_upgrade, upgrade: upgrade1, pop: 0, man: 0, mun: 35, fuel: 0, uses: 2, restriction: restriction_faction, ruleset: ruleset, unitwide_upgrade_slots: 1 }
        let!(:squad_upgrades_param) do
          [{
             squad_upgrade_id: nil,
             available_upgrade_id: available_upgrade_1_1.id,
             squad_id: nil,
             squad_uuid: '1'
           }, {
             squad_upgrade_id: nil,
             available_upgrade_id: available_upgrade_1_1.id,
             squad_id: nil,
             squad_uuid: '1'
           }]
        end

        it "raises a validation if squad exceeds the unitwide upgrade slot limit of that upgrade" do
          expect { subject }
            .to raise_error(
                  CompanyService::CompanyUpdateValidationError,
                  "Found 2 unitwide upgrade slots used for unit #{unit1.id} with #{unit1.unitwide_upgrade_slots} unitwide upgrade slots, for company #{company.id} update and squad available unit id #{available_unit_1.id}" )
        end
      end

      context "when the resource quantities are small" do
        before do
          ruleset.update!(starting_man: 200, starting_mun: 200, starting_fuel: 200)
        end
        it "raises a validation error if the new squads' cost is greater in one or more resource than the ruleset's starting resources" do
          expect {
            instance.update_company_squads(company.reload, squads_param, offmaps_param, squad_upgrades_param)
          }.to raise_error(
                 CompanyService::CompanyUpdateValidationError,
                 "Invalid squad update, negative resource balance found: -700 manpower, -985 munitions, -170 fuel"
               )
        end
      end

      it "raises a validation error if a platoon has too little pop" do
        squads_param << { squad_id: nil,
                          unit_id: unit1.id,
                          available_unit_id: available_unit_1.id,
                          name: nil,
                          vet: 0,
                          tab: "core",
                          index: 2, uuid: "10" }
        expect {
          instance.update_company_squads(company, squads_param, offmaps_param, squad_upgrades_param)
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Platoon at [core 2] has 4.0 pop, must be between 7 and 25, inclusive"
             )
      end

      it "raises a validation error if a platoon has too much pop" do
        invalid_squad_param = { squad_id: nil,
                                unit_id: unit3.id,
                                available_unit_id: available_unit_3.id,
                                name: nil,
                                vet: 0,
                                tab: "armour",
                                index: 1 }
        squads_param << invalid_squad_param
        expect {
          instance.update_company_squads(company, squads_param, offmaps_param, squad_upgrades_param)
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Platoon at [armour 1] has 26.0 pop, must be between 7 and 25, inclusive"
             )
      end

      it "raises a validation error if a platoon has too much pop from squad upgrade" do
        squads_param << { squad_id: nil,
                          unit_id: unit1.id,
                          available_unit_id: available_unit_1.id,
                          name: nil,
                          vet: 0,
                          tab: "armour",
                          index: 1,
                          uuid: '9' }
        squads_param << { squad_id: nil,
                          unit_id: unit2.id,
                          available_unit_id: available_unit_2.id,
                          name: nil,
                          vet: 0,
                          tab: "armour",
                          index: 1,
                          uuid: '10' }
        squad_upgrades_param << {
          squad_upgrade_id: nil,
          available_upgrade_id: available_upgrade_2.id,
          squad_id: nil,
          squad_uuid: '10'
        }
        expect {
          instance.update_company_squads(company, squads_param, offmaps_param, squad_upgrades_param)
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Platoon at [armour 1] has 26.0 pop, must be between 7 and 25, inclusive"
             )
      end

      it "raises a validation error if there's insufficient availability to create a squad of a certain unit" do
        available_unit_2.reload.update!(available: 1)
        expect {
          instance.update_company_squads(company.reload, squads_param, offmaps_param, squad_upgrades_param)
        }.to raise_error(
               CompanyService::CompanyUpdateValidationError,
               "Insufficient availability to create squads for available unit #{available_unit_2.id} in company #{company.id}: Existing count 0, payload count 4, available number 1"
             )
      end

      context "when there are transport uuids in the update" do
        let!(:unit1) { create :unit, transport_squad_slots: 3, transport_model_slots: 12 }
        let!(:unit2) { create :unit, model_count: 4 }
        let!(:transport_allowed_unit) { create :transport_allowed_unit, transport: unit1, allowed_unit: unit2 }
        let(:uuid1) { 'uuid1' }
        let(:uuid2) { 'uuid2' }
        let(:uuid3) { 'uuid3' }
        let(:uuid4) { 'uuid4' }
        let(:uuid5) { 'uuid5' }
        let(:transportedSquadUuids1) { [uuid2] }
        let(:transportedSquadUuids2) { [uuid4, uuid5] }
        let!(:squads_param) do
          [{
             squad_id: nil,
             unit_id: unit1.id, available_unit_id: available_unit_1.id,
             name: nil, vet: 0,
             tab: "core", index: 0,
             uuid: uuid1,
             transportedSquadUuids: transportedSquadUuids1
           }, {
             squad_id: nil,
             unit_id: unit2.id, available_unit_id: available_unit_2.id,
             name: nil, vet: 0,
             tab: "core", index: 0,
             uuid: uuid2,
             transportUuid: uuid1
           }, {
             squad_id: nil,
             unit_id: unit2.id, available_unit_id: available_unit_2.id,
             name: nil, vet: 0,
             tab: "infantry", index: 0,
             uuid: "4"
           }, {
             squad_id: nil,
             unit_id: unit2.id, available_unit_id: available_unit_2.id,
             name: nil, vet: 0,
             tab: "infantry", index: 1,
             uuid: "5"
           }, {
             squad_id: nil,
             unit_id: unit1.id, available_unit_id: available_unit_1.id,
             name: nil, vet: 0,
             tab: "infantry", index: 2,
             uuid: uuid3,
             transportedSquadUuids: transportedSquadUuids2
           }, {
             squad_id: nil,
             unit_id: unit2.id, available_unit_id: available_unit_2.id,
             name: nil, vet: 0,
             tab: "infantry", index: 2,
             uuid: uuid4,
             transportUuid: uuid3
           }, {
             squad_id: nil,
             unit_id: unit2.id, available_unit_id: available_unit_2.id,
             name: nil, vet: 0,
             tab: "infantry", index: 2,
             uuid: uuid5,
             transportUuid: uuid3
           }, {
             squad_id: nil,
             unit_id: unit3.id, available_unit_id: available_unit_3.id,
             name: nil, vet: 0,
             tab: "armour", index: 1,
             uuid: "8"
           }]
        end
        let!(:squad_upgrades_param) do
          [{
             squad_upgrade_id: nil,
             available_upgrade_id: available_upgrade_1_1.id,
             squad_id: nil,
             squad_uuid: uuid1
           }, {
             squad_upgrade_id: nil,
             available_upgrade_id: available_upgrade_1_2.id,
             squad_id: nil,
             squad_uuid: uuid2
           }, {
             squad_upgrade_id: nil,
             available_upgrade_id: available_upgrade_1_2.id,
             squad_id: nil,
             squad_uuid: '4'
           }, {
             squad_upgrade_id: nil,
             available_upgrade_id: available_upgrade_2.id,
             squad_id: nil,
             squad_uuid: uuid4
           }, {
             squad_upgrade_id: nil,
             available_upgrade_id: available_upgrade_3.id,
             squad_id: nil,
             squad_uuid: "8"
           }]
        end

        it "creates all squads" do
          subject
          squads = company.reload.squads
          expect(squads.size).to eq squads_param.size

          expect(squads.where(available_unit: available_unit_1).size).to eq 2
          expect(squads.where(available_unit: available_unit_2).size).to eq 5
          expect(squads.where(available_unit: available_unit_3).size).to eq 1
        end

        it "creates transportedSquad records for the embarked squads" do
          expect { subject }.to change { TransportedSquad.count }.by 3
          transport1 = Squad.find_by(company: company, uuid: uuid1)
          expect(transport1.squads_in_transport.count).to eq 1
          expect(transport1.squads_in_transport.first.uuid).to eq uuid2

          transport2 = Squad.find_by(company: company, uuid: uuid3)
          expect(transport2.squads_in_transport.count).to eq 2
          expect(transport2.squads_in_transport.first.uuid).to eq uuid4
          expect(transport2.squads_in_transport.second.uuid).to eq uuid5
        end

        it "creates all input SquadUpgrades for the Company" do
          subject
          squad_upgrades = company.reload.squad_upgrades
          expect(squad_upgrades.size).to eq squad_upgrades_param.size
          expect(squad_upgrades.where(available_upgrade: available_upgrade_1_1).count).to eq 1
          expect(squad_upgrades.where(available_upgrade: available_upgrade_1_2).count).to eq 2
          expect(squad_upgrades.where(available_upgrade: available_upgrade_2).count).to eq 1
          expect(squad_upgrades.where(available_upgrade: available_upgrade_3).count).to eq 1
        end

        context "when the transport uuid relationships are invalid" do
          let(:transportedSquadUuids1) { [] }
          let(:transportedSquadUuids2) { [uuid4, uuid5] }
          let!(:squads_param) do
            [{
               squad_id: nil,
               unit_id: unit1.id, available_unit_id: available_unit_1.id,
               name: nil, vet: 0,
               tab: "core", index: 0,
               uuid: uuid1,
               transportedSquadUuids: transportedSquadUuids1
             }, {
               squad_id: nil,
               unit_id: unit2.id, available_unit_id: available_unit_2.id,
               name: nil, vet: 0,
               tab: "core", index: 0,
               uuid: uuid2,
               transportUuid: uuid1
             }, {
               squad_id: nil,
               unit_id: unit1.id, available_unit_id: available_unit_1.id,
               name: nil, vet: 0,
               tab: "infantry", index: 2,
               uuid: uuid3,
               transportedSquadUuids: transportedSquadUuids2
             }, {
               squad_id: nil,
               unit_id: unit2.id, available_unit_id: available_unit_2.id,
               name: nil, vet: 0,
               tab: "infantry", index: 2,
               uuid: uuid4,
               transportUuid: uuid5
             }, {
               squad_id: nil,
               unit_id: unit2.id, available_unit_id: available_unit_2.id,
               name: nil, vet: 0,
               tab: "infantry", index: 2,
               uuid: uuid5,
               transportUuid: uuid4
             },]
          end
          let!(:squad_upgrades_param) do
            [{
               squad_upgrade_id: nil,
               available_upgrade_id: available_upgrade_1_1.id,
               squad_id: nil,
               squad_uuid: uuid1
             }, {
               squad_upgrade_id: nil,
               available_upgrade_id: available_upgrade_1_2.id,
               squad_id: nil,
               squad_uuid: uuid2
             }, {
               squad_upgrade_id: nil,
               available_upgrade_id: available_upgrade_2.id,
               squad_id: nil,
               squad_uuid: uuid4
             }]
          end

          it "creates all squads" do
            subject
            squads = company.reload.squads
            expect(squads.size).to eq squads_param.size

            expect(squads.where(available_unit: available_unit_1).size).to eq 2
            expect(squads.where(available_unit: available_unit_2).size).to eq 3
            expect(squads.where(available_unit: available_unit_3).size).to eq 0
          end

          it "does not create any transportedSquad records" do
            expect { subject }.to change { TransportedSquad.count }.by 0
            transport1 = Squad.find_by(company: company, uuid: uuid1)
            expect(transport1.squads_in_transport.count).to eq 0
            transport2 = Squad.find_by(company: company, uuid: uuid3)
            expect(transport2.squads_in_transport.count).to eq 0
          end

          it "creates all input SquadUpgrades for the Company" do
            subject
            squad_upgrades = company.reload.squad_upgrades
            expect(squad_upgrades.size).to eq squad_upgrades_param.size
            expect(squad_upgrades.where(available_upgrade: available_upgrade_1_1).count).to eq 1
            expect(squad_upgrades.where(available_upgrade: available_upgrade_1_2).count).to eq 1
            expect(squad_upgrades.where(available_upgrade: available_upgrade_2).count).to eq 1
          end
        end

        context "when the transport is not allowed to embark the passenger unit" do
          let!(:transport_allowed_unit) { nil }
          it "creates all squads" do
            subject
            squads = company.reload.squads
            expect(squads.size).to eq squads_param.size

            expect(squads.where(available_unit: available_unit_1).size).to eq 2
            expect(squads.where(available_unit: available_unit_2).size).to eq 5
            expect(squads.where(available_unit: available_unit_3).size).to eq 1
          end

          it "does not create any transportedSquad records" do
            expect { subject }.to change { TransportedSquad.count }.by 0
            transport1 = Squad.find_by(company: company, uuid: uuid1)
            expect(transport1.squads_in_transport.count).to eq 0
            transport2 = Squad.find_by(company: company, uuid: uuid3)
            expect(transport2.squads_in_transport.count).to eq 0
          end

          it "creates all input SquadUpgrades for the Company" do
            subject
            squad_upgrades = company.reload.squad_upgrades
            expect(squad_upgrades.size).to eq squad_upgrades_param.size
            expect(squad_upgrades.where(available_upgrade: available_upgrade_1_1).count).to eq 1
            expect(squad_upgrades.where(available_upgrade: available_upgrade_1_2).count).to eq 2
            expect(squad_upgrades.where(available_upgrade: available_upgrade_2).count).to eq 1
            expect(squad_upgrades.where(available_upgrade: available_upgrade_3).count).to eq 1
          end
        end

        context "when the transport does not have sufficient squad slots" do
          let!(:unit1) { create :unit, transport_squad_slots: 1, transport_model_slots: 12 }
          let!(:squads_param) do
            [{
               squad_id: nil,
               unit_id: unit1.id, available_unit_id: available_unit_1.id,
               name: nil, vet: 0,
               tab: "core", index: 0,
               uuid: uuid1,
               transportedSquadUuids: transportedSquadUuids1
             }, {
               squad_id: nil,
               unit_id: unit2.id, available_unit_id: available_unit_2.id,
               name: nil, vet: 0,
               tab: "core", index: 0,
               uuid: uuid2,
               transportUuid: uuid1
             }, {
               squad_id: nil,
               unit_id: unit1.id, available_unit_id: available_unit_1.id,
               name: nil, vet: 0,
               tab: "infantry", index: 2,
               uuid: uuid3,
               transportedSquadUuids: transportedSquadUuids2
             }, {
               squad_id: nil,
               unit_id: unit2.id, available_unit_id: available_unit_2.id,
               name: nil, vet: 0,
               tab: "infantry", index: 2,
               uuid: uuid4,
               transportUuid: uuid3
             }, {
               squad_id: nil,
               unit_id: unit2.id, available_unit_id: available_unit_2.id,
               name: nil, vet: 0,
               tab: "infantry", index: 2,
               uuid: uuid5,
               transportUuid: uuid3
             }]
          end
          let!(:squad_upgrades_param) do
            [{
               squad_upgrade_id: nil,
               available_upgrade_id: available_upgrade_1_1.id,
               squad_id: nil,
               squad_uuid: uuid1
             }, {
               squad_upgrade_id: nil,
               available_upgrade_id: available_upgrade_1_2.id,
               squad_id: nil,
               squad_uuid: uuid2
             }, {
               squad_upgrade_id: nil,
               available_upgrade_id: available_upgrade_2.id,
               squad_id: nil,
               squad_uuid: uuid4
             }]
          end

          it "creates all squads" do
            subject
            squads = company.reload.squads
            expect(squads.size).to eq squads_param.size

            expect(squads.where(available_unit: available_unit_1).size).to eq 2
            expect(squads.where(available_unit: available_unit_2).size).to eq 3
            expect(squads.where(available_unit: available_unit_3).size).to eq 0
          end

          it "only creates TransportedSquad records that fit in squad slots" do
            expect { subject }.to change { TransportedSquad.count }.by 2
            transport1 = Squad.find_by(company: company, uuid: uuid1)
            expect(transport1.squads_in_transport.count).to eq 1
            expect(transport1.squads_in_transport.first.uuid).to eq uuid2

            transport2 = Squad.find_by(company: company, uuid: uuid3)
            expect(transport2.squads_in_transport.count).to eq 1
            expect(transport2.squads_in_transport.first.uuid).to eq uuid4
          end

          it "creates all input SquadUpgrades for the Company" do
            subject
            squad_upgrades = company.reload.squad_upgrades
            expect(squad_upgrades.size).to eq squad_upgrades_param.size
            expect(squad_upgrades.where(available_upgrade: available_upgrade_1_1).count).to eq 1
            expect(squad_upgrades.where(available_upgrade: available_upgrade_1_2).count).to eq 1
            expect(squad_upgrades.where(available_upgrade: available_upgrade_2).count).to eq 1
          end
        end

        context "when the transport does not have sufficient model slots" do
          let!(:unit1) { create :unit, transport_squad_slots: 1, transport_model_slots: 5 }
          let!(:squads_param) do
            [{
               squad_id: nil,
               unit_id: unit1.id, available_unit_id: available_unit_1.id,
               name: nil, vet: 0,
               tab: "core", index: 0,
               uuid: uuid1,
               transportedSquadUuids: transportedSquadUuids1
             }, {
               squad_id: nil,
               unit_id: unit2.id, available_unit_id: available_unit_2.id,
               name: nil, vet: 0,
               tab: "core", index: 0,
               uuid: uuid2,
               transportUuid: uuid1
             }, {
               squad_id: nil,
               unit_id: unit1.id, available_unit_id: available_unit_1.id,
               name: nil, vet: 0,
               tab: "infantry", index: 2,
               uuid: uuid3,
               transportedSquadUuids: transportedSquadUuids2
             }, {
               squad_id: nil,
               unit_id: unit2.id, available_unit_id: available_unit_2.id,
               name: nil, vet: 0,
               tab: "infantry", index: 2,
               uuid: uuid4,
               transportUuid: uuid3
             }, {
               squad_id: nil,
               unit_id: unit2.id, available_unit_id: available_unit_2.id,
               name: nil, vet: 0,
               tab: "infantry", index: 2,
               uuid: uuid5,
               transportUuid: uuid3,
               upgrades: []
             }]
          end
          let!(:squad_upgrades_param) do
            [{
               squad_upgrade_id: nil,
               available_upgrade_id: available_upgrade_1_1.id,
               squad_id: nil,
               squad_uuid: uuid1
             }, {
               squad_upgrade_id: nil,
               available_upgrade_id: available_upgrade_1_2.id,
               squad_id: nil,
               squad_uuid: uuid2
             }, {
               squad_upgrade_id: nil,
               available_upgrade_id: available_upgrade_2.id,
               squad_id: nil,
               squad_uuid: uuid4
             }]
          end

          it "creates all squads" do
            subject
            squads = company.reload.squads
            expect(squads.size).to eq squads_param.size

            expect(squads.where(available_unit: available_unit_1).size).to eq 2
            expect(squads.where(available_unit: available_unit_2).size).to eq 3
            expect(squads.where(available_unit: available_unit_3).size).to eq 0
          end

          it "only creates TransportedSquad records that fit in model slots" do
            expect { subject }.to change { TransportedSquad.count }.by 2
            transport1 = Squad.find_by(company: company, uuid: uuid1)
            expect(transport1.squads_in_transport.count).to eq 1
            expect(transport1.squads_in_transport.first.uuid).to eq uuid2

            transport2 = Squad.find_by(company: company, uuid: uuid3)
            expect(transport2.squads_in_transport.count).to eq 1
            expect(transport2.squads_in_transport.first.uuid).to eq uuid4
          end

          it "creates all input SquadUpgrades for the Company" do
            subject
            squad_upgrades = company.reload.squad_upgrades
            expect(squad_upgrades.size).to eq squad_upgrades_param.size
            expect(squad_upgrades.where(available_upgrade: available_upgrade_1_1).count).to eq 1
            expect(squad_upgrades.where(available_upgrade: available_upgrade_1_2).count).to eq 1
            expect(squad_upgrades.where(available_upgrade: available_upgrade_2).count).to eq 1
          end
        end
      end
    end

    context "when Company has Squads, CompanyOffmaps, and SquadUpgrades" do
      let!(:unit4) { create :unit }
      let!(:restriction_unit4) { create :enabled_unit, unit: unit4, pop: 8, resupply: 1, resupply_max: 1, company_max: 2, restriction: restriction_doctrine, ruleset: ruleset }
      let!(:company) { instance.create_company(doctrine, name) } # Create the company here to include unit4
      let!(:available_unit_1) { company.available_units.find_by(unit_id: unit1.id) }
      let!(:available_unit_2) { company.available_units.find_by(unit_id: unit2.id) }
      let!(:available_unit_3) { company.available_units.find_by(unit_id: unit3.id) }
      let!(:available_unit_4) { company.available_units.find_by(unit_id: unit4.id) }
      let!(:available_offmap_1) { company.available_offmaps.find_by(offmap: offmap1) }
      let!(:available_offmap_2) { company.available_offmaps.find_by(offmap: offmap2) }
      let!(:available_upgrade_1_1) { company.available_upgrades.find_by(upgrade: upgrade1, unit: unit1) }
      let!(:available_upgrade_1_2) { company.available_upgrades.find_by(upgrade: upgrade1, unit: unit2) }
      let!(:available_upgrade_2) { company.available_upgrades.find_by(upgrade: upgrade2) }
      let!(:available_upgrade_3) { company.available_upgrades.find_by(upgrade: upgrade3) }

      context "without transports" do
        before do
          squad1 = create :squad, company: company, available_unit: available_unit_1, tab_category: "core", category_position: 0, uuid: '1', pop: available_unit_1.pop
          squad2 = create :squad, company: company, available_unit: available_unit_2, tab_category: "core", category_position: 0, uuid: '2', pop: available_unit_2.pop + available_upgrade_2.pop
          squad3 = create :squad, company: company, available_unit: available_unit_3, tab_category: "core", category_position: 0, uuid: '3old', pop: available_unit_3.pop

          squad4 = create :squad, company: company, available_unit: available_unit_2, tab_category: "assault", category_position: 1, uuid: '4old', pop: available_unit_2.pop

          squad5 = create :squad, company: company, available_unit: available_unit_1, tab_category: "infantry", category_position: 0, uuid: '4', pop: available_unit_1.pop
          squad6 = create :squad, company: company, available_unit: available_unit_1, tab_category: "infantry", category_position: 0, uuid: '5', pop: available_unit_1.pop

          squad7 = create :squad, company: company, available_unit: available_unit_2, tab_category: "infantry", category_position: 2, uuid: '6', pop: available_unit_2.pop

          squad8 = create :squad, company: company, available_unit: available_unit_2, tab_category: "infantry", category_position: 3, uuid: '7', pop: available_unit_2.pop
          available_unit_1.update!(available: 3)
          available_unit_2.update!(available: 1)
          available_unit_3.update!(available: 0)
          # available_unit_4 has available 1

          # Unit1: Existing count: 3, Available: 3, Payload count: 3, Resupply max: 6
          # Unit2: Existing count: 4, Available: 1, Payload count: 3, resupply max: 5
          # Unit3: Existing count: 1, Available: 0, Payload count: 0, resupply_max: 1
          # Unit4: Existing count: 0, Available: 1, Payload count: 1, resupply_max: 1

          company_offmap1 = create :company_offmap, company: company, available_offmap: available_offmap_1
          company_offmap2 = create :company_offmap, company: company, available_offmap: available_offmap_2
          available_offmap_1.update!(available: 0)
          available_offmap_2.update!(available: 2)

          squad_upgrade1 = create :squad_upgrade, squad: squad1, available_upgrade: available_upgrade_1_1
          squad_upgrade2_1 = create :squad_upgrade, squad: squad2, available_upgrade: available_upgrade_1_2
          squad_upgrade2_2 = create :squad_upgrade, squad: squad2, available_upgrade: available_upgrade_2
          squad_upgrade3 = create :squad_upgrade, squad: squad3, available_upgrade: available_upgrade_3
          squad_upgrade4 = create :squad_upgrade, squad: squad4, available_upgrade: available_upgrade_1_2

          @squads_param = [
            {
              squad_id: squad1.id,
              unit_id: unit1.id, available_unit_id: available_unit_1.id,
              name: nil, vet: 0,
              tab: "core", index: 0,
              uuid: "1"
            }, {
              squad_id: squad2.id,
              unit_id: unit2.id, available_unit_id: available_unit_2.id,
              name: nil, vet: 0,
              tab: "core", index: 0,
              uuid: "2"
            }, {
              squad_id: nil,
              unit_id: unit4.id, available_unit_id: available_unit_4.id,
              name: nil, vet: 0,
              tab: "core", index: 0,
              uuid: "3"
            }, {
              squad_id: squad5.id,
              unit_id: unit1.id, available_unit_id: available_unit_1.id,
              name: nil, vet: 0,
              tab: "infantry", index: 0,
              uuid: "4"
            }, {
              squad_id: squad6.id,
              unit_id: unit1.id, available_unit_id: available_unit_1.id,
              name: nil, vet: 0,
              tab: "infantry", index: 0,
              uuid: "5"
            }, {
              squad_id: squad7.id,
              unit_id: unit2.id, available_unit_id: available_unit_2.id,
              name: nil, vet: 0,
              tab: "infantry", index: 2,
              uuid: "6"
            }, {
              squad_id: squad8.id,
              unit_id: unit2.id, available_unit_id: available_unit_2.id,
              name: nil, vet: 0,
              tab: "infantry", index: 3,
              uuid: "7"
            }
          ]
          @offmaps_param = [{
                              company_offmap_id: company_offmap1.id,
                              available_offmap_id: available_offmap_1.id
                            }, {
                              company_offmap_id: nil,
                              available_offmap_id: available_offmap_2.id
                            }, {
                              company_offmap_id: nil,
                              available_offmap_id: available_offmap_2.id
                            }
          ]
          @squad_upgrades_param = [
            {
              squad_upgrade_id: squad_upgrade1.id,
              available_upgrade_id: available_upgrade_1_1.id,
              squad_id: squad1.id,
              squad_uuid: '1'
            }, {
              squad_upgrade_id: squad_upgrade2_1.id,
              available_upgrade_id: available_upgrade_1_2.id,
              squad_id: squad2.id,
              squad_uuid: '2'
            }, {
              squad_upgrade_id: nil,
              available_upgrade_id: available_upgrade_1_2.id,
              squad_id: nil,
              squad_uuid: '3'
            }, {
              squad_upgrade_id: nil,
              available_upgrade_id: available_upgrade_1_1.id,
              squad_id: squad6.id,
              squad_uuid: '5'
            }, {
              squad_upgrade_id: nil,
              available_upgrade_id: available_upgrade_1_2.id,
              squad_id: squad7.id,
              squad_uuid: '6'
            }, {
              squad_upgrade_id: nil,
              available_upgrade_id: available_upgrade_2.id,
              squad_id: squad8.id,
              squad_uuid: '7'
            }]
        end

        it "creates all input Squads for the Company" do
          instance.update_company_squads(company, @squads_param, @offmaps_param, @squad_upgrades_param)
          squads = company.reload.squads
          expect(squads.size).to eq @squads_param.size

          expect(squads.where(available_unit: available_unit_1).size).to eq 3
          expect(squads.where(available_unit: available_unit_2).size).to eq 3
          expect(squads.where(available_unit: available_unit_3).size).to eq 0
          expect(squads.where(available_unit: available_unit_4).size).to eq 1
        end

        it "updates the Company's AvailableUnits available value" do
          instance.update_company_squads(company, @squads_param, @offmaps_param, @squad_upgrades_param)
          available_units = company.reload.available_units
          expect(available_units.size).to eq 4
          expect(available_unit_1.reload.available).to eq 3
          expect(available_unit_2.reload.available).to eq 2
          expect(available_unit_3.reload.available).to eq 1
          expect(available_unit_4.reload.available).to eq 0
        end

        it "creates all input CompanyOffmaps for the Company" do
          company_offmap1 = company.company_offmaps.find_by(available_offmap: available_offmap_1)
          company_offmap2 = company.company_offmaps.find_by(available_offmap: available_offmap_2)
          instance.update_company_squads(company, @squads_param, @offmaps_param, @squad_upgrades_param)
          company_offmaps = company.reload.company_offmaps
          expect(company_offmaps.size).to eq @offmaps_param.size
          expect(company_offmaps.where(available_offmap: available_offmap_1).size).to eq 1
          expect(company_offmaps.where(available_offmap: available_offmap_2).size).to eq 2
          expect(company_offmaps.where(available_offmap: available_offmap_1).pluck(:id)).to include company_offmap1.id
          expect(company_offmaps.where(available_offmap: available_offmap_2).pluck(:id)).not_to include company_offmap2.id
        end

        it "updates the Company's AvailableOffmaps available value" do
          instance.update_company_squads(company, @squads_param, @offmaps_param, @squad_upgrades_param)
          available_offmaps = company.reload.available_offmaps
          expect(available_offmaps.size).to eq 2
          expect(available_offmaps.find_by(offmap: offmap1).available).to eq 0
          expect(available_offmaps.find_by(offmap: offmap2).available).to eq 1
        end

        it "creates all input SquadUpgrades for the Company" do
          squad2 = company.squads.find_by(uuid: '2')
          squad3 = company.squads.find_by(uuid: '3old')
          squad4 = company.squads.find_by(uuid: '4old')
          squad_upgrade2_2 = company.squad_upgrades.find_by(available_upgrade: available_upgrade_2, squad: squad2)
          squad_upgrade3 = company.squad_upgrades.find_by(available_upgrade: available_upgrade_3, squad: squad3)
          squad_upgrade4 = company.squad_upgrades.find_by(available_upgrade: available_upgrade_1_2, squad: squad4)
          instance.update_company_squads(company, @squads_param, @offmaps_param, @squad_upgrades_param)
          squad_upgrades = company.reload.squad_upgrades
          expect(squad_upgrades.size).to eq @squad_upgrades_param.size
          expect(squad_upgrades.where(available_upgrade: available_upgrade_1_1).size).to eq 2
          expect(squad_upgrades.where(available_upgrade: available_upgrade_1_2).size).to eq 3
          expect(squad_upgrades.where(available_upgrade: available_upgrade_2).size).to eq 1
          expect(squad_upgrades.where(available_upgrade: available_upgrade_3).size).to eq 0
          expect(squad_upgrades.where(available_upgrade: available_upgrade_1_2).pluck(:id)).not_to include squad_upgrade4.id
          expect(squad_upgrades.where(available_upgrade: available_upgrade_3).pluck(:id)).not_to include squad_upgrade3.id
          expect(SquadUpgrade.exists?(squad_upgrade2_2.id)).to be false
          expect(SquadUpgrade.exists?(squad_upgrade3.id)).to be false
          expect(SquadUpgrade.exists?(squad_upgrade4.id)).to be false
        end

        it "sets the correct squad pop for squads that no longer have a squad upgrade with nonzero pop" do
          squad2 = company.squads.find_by(uuid: '2')
          expect(squad2.pop).to eq(squad2.available_unit.pop + available_upgrade_2.pop)
          instance.update_company_squads(company, @squads_param, @offmaps_param, @squad_upgrades_param)
          expect(squad2.reload.pop).to eq (squad2.available_unit.pop)
        end

        it "sets the correct squad pop if there is a squadUpgrade with nonzero pop" do
          instance.update_company_squads(company, @squads_param, @offmaps_param, @squad_upgrades_param)
          squad_upgrades = company.reload.squad_upgrades.where(available_upgrade: available_upgrade_2)
          expect(squad_upgrades.size).to eq 1

          squad = squad_upgrades.first.squad
          expected_pop = squad.available_unit.pop + available_upgrade_2.pop
          expect(squad.pop).to eq expected_pop
        end

        it "sets the correct squad pop if there are no squad upgrades with nonzero pop for the squad" do
          instance.update_company_squads(company, @squads_param, @offmaps_param, @squad_upgrades_param)

          squad_upgrades = company.reload.squad_upgrades.where(available_upgrade: available_upgrade_2)
          expect(squad_upgrades.size).to eq 1
          pop_squad = squad_upgrades.first.squad
          squads = company.squads.where.not(id: pop_squad.id)
          squads.each do |squad|
            expected_pop = squad.available_unit.pop
            expect(squad.pop).to eq expected_pop
          end
        end

        it "raises a validation error if a Squad id is given that's not part of the Company" do
          unknown_squad_id = 99999999
          invalid_squad_param = { squad_id: unknown_squad_id,
                                  unit_id: unit1.id,
                                  available_unit_id: available_unit_1.id,
                                  name: nil,
                                  vet: 0,
                                  tab: "core",
                                  index: 0 }
          @squads_param << invalid_squad_param
          expect {
            instance.update_company_squads(company, @squads_param, @offmaps_param, @squad_upgrades_param)
          }.to raise_error(
                 CompanyService::CompanyUpdateValidationError,
                 "Given squad ids [#{unknown_squad_id}] that don't exist for the company #{company.id}"
               )
        end

        it "raises a validation error if a duplicate CompanyOffmap id is given" do
          duplicate_company_offmap_id = company.company_offmaps.find_by(available_offmap: available_offmap_1.id).id
          invalid_company_offmap_param = { company_offmap_id: duplicate_company_offmap_id, available_offmap_id: available_offmap_1.id }
          @offmaps_param << invalid_company_offmap_param
          expect { instance.update_company_squads(company, @squads_param, @offmaps_param, @squad_upgrades_param) }
            .to raise_error(
                  CompanyService::CompanyUpdateValidationError,
                  "Duplicate company offmap ids found in payload company offmap ids: [#{duplicate_company_offmap_id}]")
        end

        it "raises a validation error if a CompanyOffmap id is given that's not part of the Company" do
          unknown_company_offmap_id = 9999999
          invalid_company_offmap_param = { company_offmap_id: unknown_company_offmap_id, available_offmap_id: available_offmap_1.id }
          @offmaps_param << invalid_company_offmap_param
          expect { instance.update_company_squads(company, @squads_param, @offmaps_param, @squad_upgrades_param) }
            .to raise_error(
                  CompanyService::CompanyUpdateValidationError,
                  "Given company offmap ids [#{unknown_company_offmap_id}] that don't exist for the company #{company.id}")
        end

        it "raises a validation error if an invalid Unit id is given" do
          unknown_unit_id = 99999999
          invalid_squad_param = { squad_id: nil,
                                  unit_id: unknown_unit_id,
                                  available_unit_id: unknown_unit_id,
                                  name: nil,
                                  vet: 0,
                                  tab: "core",
                                  index: 0 }
          @squads_param << invalid_squad_param
          expect {
            instance.update_company_squads(company, @squads_param, @offmaps_param, @squad_upgrades_param)
          }.to raise_error(
                 CompanyService::CompanyUpdateValidationError,
                 "Invalid unit id(s) given in company squad update: [#{unknown_unit_id}]"
               )
        end

        it "raises a validation error if an AvailableUnit id is given that doesn't match any AvailableUnit in the Company" do
          new_unit = create :unit
          new_available_unit = create :available_unit, unit: new_unit
          invalid_squad_param = { squad_id: nil,
                                  unit_id: new_unit.id,
                                  available_unit_id: new_available_unit.id,
                                  name: nil,
                                  vet: 0,
                                  tab: "core",
                                  index: 0 }
          @squads_param << invalid_squad_param
          expect {
            instance.update_company_squads(company, @squads_param, @offmaps_param, @squad_upgrades_param)
          }.to raise_error(
                 CompanyService::CompanyUpdateValidationError,
                 "Invalid available_unit_id(s) given in company #{company.id} squad update: [#{new_available_unit.id}]"
               )
        end

        it "raises a validation error if an AvailableOffmap id is given that doesn't match any AvailableOffmap in the Company" do
          new_offmap = create :offmap
          new_available_offmap = create :available_offmap, offmap: new_offmap # company will not be the same
          invalid_offmap_param = { company_offmap_id: nil, available_offmap_id: new_available_offmap.id }
          @offmaps_param << invalid_offmap_param
          expect {
            instance.update_company_squads(company, @squads_param, @offmaps_param, @squad_upgrades_param)
          }.to raise_error(
                 CompanyService::CompanyUpdateValidationError,
                 "Invalid available_offmap_id(s) given in company #{company.id} squad update: [#{new_available_offmap.id}]"
               )
        end

        context "when the resource quantities are small" do
          before do
            ruleset.update!(starting_man: 200, starting_mun: 200, starting_fuel: 200)
          end
          it "raises a validation error if the new squads' cost is greater in one or more resource than the ruleset's starting resources" do
            squad2 = Squad.find_by(uuid: '2')
            @squad_upgrades_param << {
              squad_upgrade_id: nil,
              available_upgrade_id: available_upgrade_2.id,
              squad_id: squad2.id,
              squad_uuid: '2'
            }

            expect {
              instance.update_company_squads(company.reload, @squads_param, @offmaps_param, @squad_upgrades_param)
            }.to raise_error(
                   CompanyService::CompanyUpdateValidationError,
                   "Invalid squad update, negative resource balance found: -700 manpower, -985 munitions, -80 fuel"
                 )
          end
        end

        it "raises a validation error if a platoon has too little pop" do
          @squads_param << { squad_id: nil,
                             unit_id: unit1.id,
                             available_unit_id: available_unit_1.id,
                             name: nil,
                             vet: 0,
                             tab: "core",
                             index: 3 }
          expect {
            instance.update_company_squads(company, @squads_param, @offmaps_param, @squad_upgrades_param)
          }.to raise_error(
                 CompanyService::CompanyUpdateValidationError,
                 "Platoon at [core 3] has 4.0 pop, must be between 7 and 25, inclusive"
               )
        end

        it "raises a validation error if a platoon has too much pop including squad upgrades" do
          squad2 = Squad.find_by(uuid: '2')
          @squads_param << { squad_id: nil,
                             unit_id: unit3.id,
                             available_unit_id: available_unit_3.id,
                             name: nil,
                             vet: 0,
                             tab: "core",
                             index: 0 }
          @squad_upgrades_param << {
            squad_upgrade_id: nil,
            available_upgrade_id: available_upgrade_2.id,
            squad_id: squad2.id,
            squad_uuid: '2'
          }
          expect {
            instance.update_company_squads(company, @squads_param, @offmaps_param, @squad_upgrades_param)
          }.to raise_error(
                 CompanyService::CompanyUpdateValidationError,
                 "Platoon at [core 0] has 34.0 pop, must be between 7 and 25, inclusive"
               )
        end

        it "raises a validation error if there's insufficient availability to create a squad of a certain unit" do
          available_unit_4.update!(available: 0)
          expect {
            instance.update_company_squads(company.reload, @squads_param, @offmaps_param, @squad_upgrades_param)
          }.to raise_error(
                 CompanyService::CompanyUpdateValidationError,
                 "Insufficient availability to create squads for available unit #{available_unit_4.id} in company #{company.id}: Existing count 0, payload count 1, available number 0"
               )
        end
      end

      context "when there are transport uuids in the squads" do
        let!(:unit1) { create :unit, transport_squad_slots: 3, transport_model_slots: 12 }
        let!(:unit2) { create :unit, model_count: 4 }
        let!(:transport_allowed_unit) { create :transport_allowed_unit, transport: unit1, allowed_unit: unit2 }
        let(:uuid1) { 'uuid1' }
        let(:uuid2) { 'uuid2' }
        let(:uuid3) { 'uuid3' }
        let(:uuid4) { 'uuid4' }
        let(:uuid5) { 'uuid5' }
        let(:uuid6) { 'uuid6' }
        let(:uuid7) { 'uuid7' }
        let(:uuid8) { 'uuid8' }
        let(:new_uuid1) { 'nuuid1' }
        let(:new_uuid2) { 'nuuid2' }
        let(:new_uuid3) { 'nuuid3' }
        let(:transportedSquadUuids1) { [uuid2] }
        let(:transportedSquadUuids2) { [new_uuid1] }
        let(:transportedSquadUuids3) { [new_uuid3] }

        context "with no validation issues" do
          let!(:squad1) { create :squad, company: company, available_unit: available_unit_1, tab_category: "core", category_position: 0, uuid: uuid1 }
          let!(:squad2) { create :squad, company: company, available_unit: available_unit_2, tab_category: "core", category_position: 0, uuid: uuid2 }
          let!(:squad3) { create :squad, company: company, available_unit: available_unit_1, tab_category: "core", category_position: 1, uuid: uuid3 }
          let!(:squad4) { create :squad, company: company, available_unit: available_unit_2, tab_category: "core", category_position: 1, uuid: uuid4 }
          let!(:squad5) { create :squad, company: company, available_unit: available_unit_1, tab_category: "core", category_position: 2, uuid: uuid5 }
          let!(:squad6) { create :squad, company: company, available_unit: available_unit_2, tab_category: "core", category_position: 2, uuid: uuid6 }
          let!(:squad7) { create :squad, company: company, available_unit: available_unit_1, tab_category: "core", category_position: 3, uuid: uuid7 }
          let!(:squad8) { create :squad, company: company, available_unit: available_unit_2, tab_category: "core", category_position: 3, uuid: uuid8 }
          let!(:transported_squad1) { create :transported_squad, transport_squad: squad1, embarked_squad: squad2 }
          let!(:transported_squad2) { create :transported_squad, transport_squad: squad3, embarked_squad: squad4 }
          let!(:transported_squad3) { create :transported_squad, transport_squad: squad5, embarked_squad: squad6 }
          let!(:transported_squad4) { create :transported_squad, transport_squad: squad7, embarked_squad: squad8 }

          # Transport 1 still has passenger 2, just changed index -> no change
          # Transport 3 no longer exists, passenger 4 still exists -> destroyed transported_squad2
          # Transport 5 exists, passenger 6 no longer exists, get new passenger nuuid1 -> destroyed transported_squad3, created new transported_squad
          # Transport 7 no longer exists, passenger 8 no longer exists -> destroyed transported_squad 4
          # New transport nuuid2, passenger nuuid3 -> created new transported_squad
          let(:squads_param) do
            [
              {
                squad_id: squad1.id,
                unit_id: unit1.id,
                available_unit_id: available_unit_1.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 1,
                uuid: uuid1,
                transportedSquadUuids: transportedSquadUuids1,
                upgrades: []
              },
              {
                squad_id: squad2.id,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 1,
                uuid: uuid2,
                transportUuid: uuid1,
                upgrades: []
              },
              {
                squad_id: squad4.id,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 1,
                uuid: uuid4,
                upgrades: []
              },
              {
                squad_id: squad5.id,
                unit_id: unit1.id,
                available_unit_id: available_unit_1.id,
                name: nil,
                vet: 0,
                tab: "infantry",
                index: 0,
                uuid: uuid5,
                transportedSquadUuids: transportedSquadUuids2,
                upgrades: []
              },
              {
                squad_id: nil,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "infantry",
                index: 0,
                uuid: new_uuid1,
                transportUuid: uuid5,
                upgrades: []
              },
              {
                squad_id: nil,
                unit_id: unit1.id,
                available_unit_id: available_unit_1.id,
                name: nil,
                vet: 0,
                tab: "infantry",
                index: 2,
                uuid: new_uuid2,
                transportedSquadUuids: transportedSquadUuids3,
                upgrades: []
              },
              {
                squad_id: nil,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "infantry",
                index: 2,
                uuid: new_uuid3,
                transportUuid: new_uuid2,
                upgrades: []
              }
            ]
          end

          subject { instance.update_company_squads(company, squads_param, offmaps_param, squad_upgrades_param) }

          before do
            available_unit_1.update!(available: 2)
            available_unit_2.update!(available: 1)
            available_unit_3.update!(available: 0)
          end

          it "creates all input Squads for the Company" do
            subject
            squads = company.reload.squads
            expect(squads.size).to eq squads_param.size

            expect(squads.where(available_unit: available_unit_1).size).to eq 3
            expect(squads.where(available_unit: available_unit_2).size).to eq 4
            expect(squads.where(available_unit: available_unit_3).size).to eq 0
            expect(squads.where(available_unit: available_unit_4).size).to eq 0
          end

          it "updates the Company's AvailableUnits available value" do
            subject
            available_units = company.reload.available_units
            expect(available_units.size).to eq 4
            expect(available_unit_1.reload.available).to eq 3
            expect(available_unit_2.reload.available).to eq 1
            expect(available_unit_3.reload.available).to eq 0
            expect(available_unit_4.reload.available).to eq 1
          end

          it "creates TransportedSquads for any new transport links" do
            expect(TransportedSquad.count).to eq 4
            expect { subject }.to change { TransportedSquad.count }.by -1
            new_transport = Squad.find_by(company: company, uuid: new_uuid2)
            expect(new_transport.squads_in_transport.size).to eq 1
            expect(new_transport.squads_in_transport.first.uuid).to eq new_uuid3
          end

          it "does not modify any unchanged TransportedSquad links" do
            subject
            expect(squad1.reload.squads_in_transport.count).to eq 1
            expect(squad1.squads_in_transport.first).to eq squad2.reload
          end

          it "destroys TransportedSquads if the transport no longer exists" do
            subject

            expect(Squad.exists?(squad3.id)).to be false
            expect(TransportedSquad.exists?(transport_squad: transported_squad2.transport_squad, embarked_squad: transported_squad2.embarked_squad)).to be false
            expect(squad4.reload.embarked_transport).to be nil

            expect(Squad.exists?(squad7.id)).to be false
            expect(Squad.exists?(squad8.id)).to be false
            expect(TransportedSquad.exists?(transport_squad: transported_squad4.transport_squad, embarked_squad: transported_squad4.embarked_squad)).to be false
          end

          it "destroys TransportedSquads if the embarked squad no longer exists" do
            subject

            expect(Squad.exists?(squad6.id)).to be false
            expect(TransportedSquad.exists?(transport_squad: transported_squad3.transport_squad, embarked_squad: transported_squad3.embarked_squad)).to be false
            expect(squad5.reload.squads_in_transport.count).to eq 1
            expect(squad5.squads_in_transport.first.uuid).to eq new_uuid1
          end
        end

        context "when the transport uuid relationships are invalid" do
          let!(:squad1) { create :squad, company: company, available_unit: available_unit_1, tab_category: "core", category_position: 0, uuid: uuid1 }
          let!(:squad2) { create :squad, company: company, available_unit: available_unit_2, tab_category: "core", category_position: 0, uuid: uuid2 }
          let!(:squad3) { create :squad, company: company, available_unit: available_unit_1, tab_category: "core", category_position: 1, uuid: uuid3 }
          let!(:squad4) { create :squad, company: company, available_unit: available_unit_2, tab_category: "core", category_position: 1, uuid: uuid4 }
          let!(:transported_squad1) { create :transported_squad, transport_squad: squad1, embarked_squad: squad2 }
          let!(:transported_squad2) { create :transported_squad, transport_squad: squad3, embarked_squad: squad4 }
          let(:transportedSquadUuids1) { [] }
          let(:transportedSquadUuids2) { [uuid4, new_uuid1, new_uuid2] }

          let(:squads_param) do
            [
              {
                squad_id: squad1.id,
                unit_id: unit1.id,
                available_unit_id: available_unit_1.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 0,
                uuid: uuid1,
                transportedSquadUuids: transportedSquadUuids1,
                upgrades: []
              },
              {
                squad_id: squad2.id,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 0,
                uuid: uuid2,
                transportUuid: uuid1,
                upgrades: []
              },
              {
                squad_id: squad3.id,
                unit_id: unit1.id,
                available_unit_id: available_unit_1.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 1,
                uuid: uuid3,
                transportedSquadUuids: transportedSquadUuids2,
                upgrades: []
              },
              {
                squad_id: squad4.id,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 1,
                uuid: uuid4,
                transportUuid: nil,
                upgrades: []
              },
              {
                squad_id: nil,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 1,
                uuid: new_uuid1,
                transportUuid: nil,
                upgrades: []
              },
              {
                squad_id: nil,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 1,
                uuid: new_uuid2,
                transportUuid: uuid3,
                upgrades: []
              }
            ]
          end

          before do
            available_unit_1.update!(available: 4)
            available_unit_2.update!(available: 3)
          end

          it "creates all squads" do
            subject
            squads = company.reload.squads
            expect(squads.size).to eq squads_param.size

            expect(squads.where(available_unit: available_unit_1).size).to eq 2
            expect(squads.where(available_unit: available_unit_2).size).to eq 4
            expect(squads.where(available_unit: available_unit_3).size).to eq 0
          end

          it "removes invalid TransportedSquads" do
            expect { subject }.to change { TransportedSquad.count }.by -1

            expect(TransportedSquad.exists?(transport_squad: transported_squad1.transport_squad, embarked_squad: transported_squad1.embarked_squad)).to be false
            expect(squad1.reload.squads_in_transport.count).to eq 0
            expect(squad2.reload.embarked_transport).to be nil

            expect(TransportedSquad.exists?(transport_squad: transported_squad2.transport_squad, embarked_squad: transported_squad2.embarked_squad)).to be false
            expect(squad3.reload.squads_in_transport.count).to eq 1
            expect(squad4.reload.embarked_transport).to be nil
          end

          it "only creates a valid TransportedSquad link" do
            subject

            expect(squad3.reload.squads_in_transport.count).to eq 1
            expect(squad3.squads_in_transport.first.uuid).to eq new_uuid2
            expect(Squad.find_by(company: company, uuid: new_uuid2).embarked_transport).to eq squad3
          end
        end

        context "when the transport is not allowed to embark the passenger unit" do
          let!(:transport_allowed_unit) { nil }
          let!(:squad1) { create :squad, company: company, available_unit: available_unit_1, tab_category: "core", category_position: 0, uuid: uuid1 }
          let!(:squad2) { create :squad, company: company, available_unit: available_unit_2, tab_category: "core", category_position: 0, uuid: uuid2 }
          let!(:squad3) { create :squad, company: company, available_unit: available_unit_1, tab_category: "core", category_position: 1, uuid: uuid3 }
          let!(:squad4) { create :squad, company: company, available_unit: available_unit_2, tab_category: "core", category_position: 1, uuid: uuid4 }
          let!(:transported_squad1) { create :transported_squad, transport_squad: squad1, embarked_squad: squad2 }
          let!(:transported_squad2) { create :transported_squad, transport_squad: squad3, embarked_squad: squad4 }
          let(:transportedSquadUuids1) { [uuid2] }
          let(:transportedSquadUuids2) { [uuid4, new_uuid1] }

          let(:squads_param) do
            [
              {
                squad_id: squad1.id,
                unit_id: unit1.id,
                available_unit_id: available_unit_1.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 0,
                uuid: uuid1,
                transportedSquadUuids: transportedSquadUuids1,
                upgrades: []
              },
              {
                squad_id: squad2.id,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 0,
                uuid: uuid2,
                transportUuid: uuid1,
                upgrades: []
              },
              {
                squad_id: squad3.id,
                unit_id: unit1.id,
                available_unit_id: available_unit_1.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 1,
                uuid: uuid3,
                transportedSquadUuids: transportedSquadUuids2,
                upgrades: []
              },
              {
                squad_id: squad4.id,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 1,
                uuid: uuid4,
                transportUuid: uuid3,
                upgrades: []
              },
              {
                squad_id: nil,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 1,
                uuid: new_uuid1,
                transportUuid: uuid3,
                upgrades: []
              }
            ]
          end

          before do
            available_unit_1.update!(available: 4)
            available_unit_2.update!(available: 3)
          end

          it "creates all squads" do
            subject
            squads = company.reload.squads
            expect(squads.size).to eq squads_param.size

            expect(squads.where(available_unit: available_unit_1).size).to eq 2
            expect(squads.where(available_unit: available_unit_2).size).to eq 3
            expect(squads.where(available_unit: available_unit_3).size).to eq 0
          end

          it "destroys existing TransportedSquad records and does not create any new ones" do
            expect { subject }.to change { TransportedSquad.count }.by -2
            expect(TransportedSquad.exists?(transport_squad: transported_squad1.transport_squad, embarked_squad: transported_squad1.embarked_squad)).to be false
            expect(TransportedSquad.exists?(transport_squad: transported_squad2.transport_squad, embarked_squad: transported_squad2.embarked_squad)).to be false
            expect(TransportedSquad.count).to eq 0
          end
        end

        context "when the transport does not have sufficient squad slots" do
          let!(:unit1) { create :unit, transport_squad_slots: 1, transport_model_slots: 12 }
          let!(:squad1) { create :squad, company: company, available_unit: available_unit_1, tab_category: "core", category_position: 0, uuid: uuid1 }
          let!(:squad2) { create :squad, company: company, available_unit: available_unit_2, tab_category: "core", category_position: 0, uuid: uuid2 }
          let!(:squad3) { create :squad, company: company, available_unit: available_unit_1, tab_category: "core", category_position: 1, uuid: uuid3 }
          let!(:squad4) { create :squad, company: company, available_unit: available_unit_2, tab_category: "core", category_position: 1, uuid: uuid4 }
          let!(:squad5) { create :squad, company: company, available_unit: available_unit_2, tab_category: "core", category_position: 1, uuid: uuid5 }
          let!(:transported_squad1) { create :transported_squad, transport_squad: squad1, embarked_squad: squad2 }
          let!(:transported_squad2) { create :transported_squad, transport_squad: squad3, embarked_squad: squad4 }
          let!(:transported_squad3) { create :transported_squad, transport_squad: squad3, embarked_squad: squad5 }
          let(:transportedSquadUuids1) { [uuid2] }
          let(:transportedSquadUuids2) { [uuid4, uuid5, new_uuid1] }

          let(:squads_param) do
            [
              {
                squad_id: squad1.id,
                unit_id: unit1.id,
                available_unit_id: available_unit_1.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 0,
                uuid: uuid1,
                transportedSquadUuids: transportedSquadUuids1,
                upgrades: []
              },
              {
                squad_id: squad2.id,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 0,
                uuid: uuid2,
                transportUuid: uuid1,
                upgrades: []
              },
              {
                squad_id: squad3.id,
                unit_id: unit1.id,
                available_unit_id: available_unit_1.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 1,
                uuid: uuid3,
                transportedSquadUuids: transportedSquadUuids2,
                upgrades: []
              },
              {
                squad_id: squad4.id,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 1,
                uuid: uuid4,
                transportUuid: uuid3,
                upgrades: []
              },
              {
                squad_id: squad5.id,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 1,
                uuid: uuid5,
                transportUuid: uuid3,
                upgrades: []
              },
              {
                squad_id: nil,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 1,
                uuid: new_uuid1,
                transportUuid: uuid3,
                upgrades: []
              }
            ]
          end

          before do
            available_unit_1.update!(available: 4)
            available_unit_2.update!(available: 2)
          end

          it "creates all squads" do
            subject
            squads = company.reload.squads
            expect(squads.size).to eq squads_param.size

            expect(squads.where(available_unit: available_unit_1).size).to eq 2
            expect(squads.where(available_unit: available_unit_2).size).to eq 4
            expect(squads.where(available_unit: available_unit_3).size).to eq 0
          end

          it "destroys TransportedSquad records that don't fit the squad slots and does not create any new ones" do
            expect { subject }.to change { TransportedSquad.count }.by -1
            expect(TransportedSquad.exists?(transport_squad: transported_squad1.transport_squad, embarked_squad: transported_squad1.embarked_squad)).to be true
            expect(TransportedSquad.exists?(transport_squad: transported_squad2.transport_squad, embarked_squad: transported_squad2.embarked_squad)).to be true
            expect(TransportedSquad.exists?(transport_squad: transported_squad3.transport_squad, embarked_squad: transported_squad3.embarked_squad)).to be false
            expect(squad3.reload.squads_in_transport.count).to eq 1
            expect(squad3.reload.squads_in_transport.first).to eq squad4
            expect(squad5.reload.embarked_transport).to be nil
            expect(Squad.find_by(company: company, uuid: new_uuid1).embarked_transport).to be nil
          end
        end

        context "when the transport does not have sufficient model slots" do
          let!(:unit1) { create :unit, transport_squad_slots: 1, transport_model_slots: 5 }
          let!(:squad1) { create :squad, company: company, available_unit: available_unit_1, tab_category: "core", category_position: 0, uuid: uuid1 }
          let!(:squad2) { create :squad, company: company, available_unit: available_unit_2, tab_category: "core", category_position: 0, uuid: uuid2 }
          let!(:squad3) { create :squad, company: company, available_unit: available_unit_1, tab_category: "core", category_position: 1, uuid: uuid3 }
          let!(:squad4) { create :squad, company: company, available_unit: available_unit_2, tab_category: "core", category_position: 1, uuid: uuid4 }
          let!(:squad5) { create :squad, company: company, available_unit: available_unit_2, tab_category: "core", category_position: 1, uuid: uuid5 }
          let!(:transported_squad1) { create :transported_squad, transport_squad: squad1, embarked_squad: squad2 }
          let!(:transported_squad2) { create :transported_squad, transport_squad: squad3, embarked_squad: squad4 }
          let!(:transported_squad3) { create :transported_squad, transport_squad: squad3, embarked_squad: squad5 }
          let(:transportedSquadUuids1) { [uuid2] }
          let(:transportedSquadUuids2) { [uuid4, uuid5, new_uuid1] }

          let(:squads_param) do
            [
              {
                squad_id: squad1.id,
                unit_id: unit1.id,
                available_unit_id: available_unit_1.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 0,
                uuid: uuid1,
                transportedSquadUuids: transportedSquadUuids1,
                upgrades: []
              },
              {
                squad_id: squad2.id,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 0,
                uuid: uuid2,
                transportUuid: uuid1,
                upgrades: []
              },
              {
                squad_id: squad3.id,
                unit_id: unit1.id,
                available_unit_id: available_unit_1.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 1,
                uuid: uuid3,
                transportedSquadUuids: transportedSquadUuids2,
                upgrades: []
              },
              {
                squad_id: squad4.id,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 1,
                uuid: uuid4,
                transportUuid: uuid3,
                upgrades: []
              },
              {
                squad_id: squad5.id,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 1,
                uuid: uuid5,
                transportUuid: uuid3,
                upgrades: []
              },
              {
                squad_id: nil,
                unit_id: unit2.id,
                available_unit_id: available_unit_2.id,
                name: nil,
                vet: 0,
                tab: "core",
                index: 1,
                uuid: new_uuid1,
                transportUuid: uuid3,
                upgrades: []
              }
            ]
          end

          before do
            available_unit_1.update!(available: 4)
            available_unit_2.update!(available: 2)
          end

          it "creates all squads" do
            subject
            squads = company.reload.squads
            expect(squads.size).to eq squads_param.size

            expect(squads.where(available_unit: available_unit_1).size).to eq 2
            expect(squads.where(available_unit: available_unit_2).size).to eq 4
            expect(squads.where(available_unit: available_unit_3).size).to eq 0
          end

          it "destroys TransportedSquad records that don't fit the squad slots and does not create any new ones" do
            expect { subject }.to change { TransportedSquad.count }.by -1
            expect(TransportedSquad.exists?(transported_squad1.id)).to be true
            expect(TransportedSquad.exists?(transport_squad: transported_squad1.transport_squad, embarked_squad: transported_squad1.embarked_squad)).to be true
            expect(TransportedSquad.exists?(transport_squad: transported_squad2.transport_squad, embarked_squad: transported_squad2.embarked_squad)).to be true
            expect(TransportedSquad.exists?(transport_squad: transported_squad3.transport_squad, embarked_squad: transported_squad3.embarked_squad)).to be false
            expect(squad3.reload.squads_in_transport.count).to eq 1
            expect(squad3.reload.squads_in_transport.first).to eq squad4
            expect(squad5.reload.embarked_transport).to be nil
            expect(Squad.find_by(company: company, uuid: new_uuid1).embarked_transport).to be nil
          end
        end
      end
    end
  end

  describe "#delete_company" do
    subject { instance.delete_company(@company) }

    before do
      @company = instance.create_company(doctrine, name)
      @available_unit_1 = @company.available_units.find_by(unit: unit1)
      @available_unit_2 = @company.available_units.find_by(unit: unit2)
      @available_unit_3 = @company.available_units.find_by(unit: unit3)

      squad1 = create :squad, company: @company, available_unit: @available_unit_1, tab_category: "core", category_position: 0
      squad2 = create :squad, company: @company, available_unit: @available_unit_2, tab_category: "core", category_position: 0
      squad3 = create :squad, company: @company, available_unit: @available_unit_3, tab_category: "core", category_position: 3

      @available_offmap_1 = @company.available_offmaps.find_by(offmap: offmap1)
      @available_offmap_2 = @company.available_offmaps.find_by(offmap: offmap2)
      create :company_offmap, company: @company, available_offmap: @available_offmap_1
      create :company_offmap, company: @company, available_offmap: @available_offmap_2

      @available_upgrade_1_1 = @company.available_upgrades.find_by(upgrade: upgrade1, unit: unit1)
      @available_upgrade_1_2 = @company.available_upgrades.find_by(upgrade: upgrade1, unit: unit2)
      @available_upgrade_2 = @company.available_upgrades.find_by(upgrade: upgrade2)
      @available_upgrade_3 = @company.available_upgrades.find_by(upgrade: upgrade3)
      create :squad_upgrade, squad: squad1, available_upgrade: @available_upgrade_1_1
      create :squad_upgrade, squad: squad2, available_upgrade: @available_upgrade_1_2
      create :squad_upgrade, squad: squad2, available_upgrade: @available_upgrade_2
      create :squad_upgrade, squad: squad3, available_upgrade: @available_upgrade_3
    end

    it "destroys the Company" do
      expect { subject }.to change { Company.count }.by -1
      expect { @company.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
    it "destroys the Company's AvailableUnits" do
      expect { subject }.to change { AvailableUnit.count }.by -3
      expect(AvailableUnit.where(company_id: @company.id).size).to eq 0
    end
    it "destroys the Company's Squads" do
      expect { subject }.to change { Squad.count }.by -3
      expect(Squad.where(company_id: @company.id).size).to eq 0
    end

    it "destroys the Company's AvailableOffmaps" do
      expect { subject }.to change { AvailableOffmap.count }.by -2
      expect(AvailableOffmap.where(company_id: @company.id).size).to eq 0
    end
    it "destroys the Company's CompanyOffmaps" do
      expect { subject }.to change { CompanyOffmap.count }.by -2
      expect(CompanyOffmap.where(company_id: @company.id).size).to eq 0
    end

    it "destroys the Company's AvailableUpgrades" do
      expect { subject }.to change { AvailableUpgrade.count }.by -4
      expect(AvailableUpgrade.where(company_id: @company.id).size).to eq 0
    end
    it "destroys the Company's SquadUpgrades" do
      expect { subject }.to change { SquadUpgrade.count }.by -4
      expect(SquadUpgrade.joins(:squad).where(squad: { company_id: @company.id }).size).to eq 0
    end
  end

  describe "#recalculate_resources" do
    before do
      @company = instance.create_company(doctrine, name)
      @available_unit_1 = @company.available_units.find_by(unit: unit1)
      @available_unit_2 = @company.available_units.find_by(unit: unit2)
      @available_unit_3 = @company.available_units.find_by(unit: unit3)

      squad1 = create :squad, company: @company, available_unit: @available_unit_1, tab_category: "core", category_position: 0
      squad2 = create :squad, company: @company, available_unit: @available_unit_2, tab_category: "core", category_position: 0
      squad3 = create :squad, company: @company, available_unit: @available_unit_3, tab_category: "core", category_position: 3

      @available_upgrade_1_1 = @company.available_upgrades.find_by(upgrade: upgrade1, unit: unit1)
      @available_upgrade_1_2 = @company.available_upgrades.find_by(upgrade: upgrade1, unit: unit2)
      @available_upgrade_2 = @company.available_upgrades.find_by(upgrade: upgrade2)
      @available_upgrade_3 = @company.available_upgrades.find_by(upgrade: upgrade3)
      create :squad_upgrade, squad: squad1, available_upgrade: @available_upgrade_1_1
      create :squad_upgrade, squad: squad2, available_upgrade: @available_upgrade_1_2
      create :squad_upgrade, squad: squad2, available_upgrade: @available_upgrade_2
      create :squad_upgrade, squad: squad3, available_upgrade: @available_upgrade_3
    end

    it "calculates the correct resources remaining" do
      man, mun, fuel, pop = instance.recalculate_resources(@company)
      expect(man).to eq ruleset.starting_man - @available_unit_1.man - @available_unit_2.man - @available_unit_3.man - @available_upgrade_1_1.man - @available_upgrade_1_2.man - @available_upgrade_2.man - @available_upgrade_3.man
      expect(mun).to eq ruleset.starting_mun - @available_unit_1.mun - @available_unit_2.mun - @available_unit_3.mun - @available_upgrade_1_1.mun - @available_upgrade_1_2.mun - @available_upgrade_2.mun - @available_upgrade_3.mun
      expect(fuel).to eq ruleset.starting_fuel - @available_unit_1.fuel - @available_unit_2.fuel - @available_unit_3.fuel - @available_upgrade_1_1.fuel - @available_upgrade_1_2.fuel - @available_upgrade_2.fuel - @available_upgrade_3.fuel
      expect(pop).to eq @available_unit_1.pop + @available_unit_2.pop + @available_unit_3.pop + @available_upgrade_1_1.pop + @available_upgrade_1_2.pop + @available_upgrade_2.pop + @available_upgrade_3.pop
    end
  end

  describe "#can_create_company" do
    it "can create when the player does not have the max number of companies for that side" do
      create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset
      expect(instance.send(:can_create_company, doctrine)).to be true
    end

    it "cannot create when the player has the max number of companies for that side" do
      create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset
      create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset
      expect(instance.send(:can_create_company, doctrine)).to be false
    end
  end

  describe "#can_update_company" do
    it "returns true when the player is associated with the company" do
      company = create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset
      expect(instance.send(:can_update_company, company, false)).to be true
    end
    it "returns false when the player is not associated with the company" do
      player2 = create :player
      company = create :company, player: player2, faction: faction, doctrine: doctrine, ruleset: ruleset
      expect(instance.send(:can_update_company, company, false)).to be false
    end
    it "returns true when the player is not associated with the company but the override is true" do
      player2 = create :player
      company = create :company, player: player2, faction: faction, doctrine: doctrine, ruleset: ruleset
      expect(instance.send(:can_update_company, company, true)).to be true
    end
  end

  describe "#validate_incoming_squad_ids" do
    it "passes when the incoming squad ids are not duplicated and are a subset of the existing squad ids" do
      incoming_ids = [1, 2, 3, 4]
      existing_ids = [1, 2, 3, 4, 5, 6]
      expect { instance.send(:validate_incoming_squad_ids, incoming_ids, existing_ids, 1) }.
        not_to raise_error
    end
    it "fails when the incoming squad ids have duplicates" do
      incoming_ids = [1, 2, 2, 3, 4, 4]
      existing_ids = []
      expect { instance.send(:validate_incoming_squad_ids, incoming_ids, existing_ids, 1) }.
        to raise_error(CompanyService::CompanyUpdateValidationError, "Duplicate squad ids found in payload squad ids: [2, 4]")
    end
    it "fails when the incoming squad ids are not duplicated but are not a subset of the existing squad ids" do
      incoming_ids = [1, 2, 3, 4, 7, 8]
      existing_ids = [1, 2, 3, 4, 5, 6]
      expect { instance.send(:validate_incoming_squad_ids, incoming_ids, existing_ids, 1) }.
        to raise_error(CompanyService::CompanyUpdateValidationError, "Given squad ids [7, 8] that don't exist for the company 1")
    end
  end

  describe "#validate_squad_units_exist" do
    it "passes when the unique units match unique units" do
      uniq_unit_ids = [1, 2, 3]
      uniq_units_by_id = { 1 => Unit.new, 2 => Unit.new, 3 => Unit.new }
      expect { instance.send(:validate_squad_units_exist, uniq_unit_ids, uniq_units_by_id) }.
        not_to raise_error
    end
    it "fails when the unique units don't match unique units" do
      uniq_unit_ids = [1, 2, 3]
      uniq_units_by_id = { 1 => Unit.new, 2 => Unit.new }
      expect { instance.send(:validate_squad_units_exist, uniq_unit_ids, uniq_units_by_id) }.
        to raise_error(CompanyService::CompanyUpdateValidationError, "Invalid unit id(s) given in company squad update: [3]")
    end
  end

  describe "#validate_squad_available_units_exist" do
    let!(:company) { create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset }
    let!(:available_unit_1) { create :available_unit, company: company, unit: unit1 }
    let!(:available_unit_2) { create :available_unit, company: company, unit: unit2 }

    it "passes when all available unit ids match an available unit for the company" do
      uniq_available_unit_ids_new = [available_unit_1.id, available_unit_2.id]
      available_units = [available_unit_1, available_unit_2]
      expect { instance.send(:validate_squad_available_units_exist, uniq_available_unit_ids_new, available_units, company.id) }.
        not_to raise_error
    end

    it "fails when not all available unit ids match an available unit for the company" do
      unknown_id = 1234
      uniq_available_unit_ids_new = [available_unit_1.id, unknown_id]
      available_units = [available_unit_1, available_unit_2]
      expect { instance.send(:validate_squad_available_units_exist, uniq_available_unit_ids_new, available_units, company.id) }.
        to raise_error(CompanyService::CompanyUpdateValidationError,
                       "Invalid available_unit_id(s) given in company #{company.id} squad update: [#{unknown_id}]")
    end
  end

  describe "#validate_squad_units_available" do
    let!(:company) { create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset }
    let!(:available_unit_1) { create :available_unit, company: company, unit: unit1 }
    let!(:available_unit_2) { create :available_unit, company: company, unit: unit2 }

    it "passes when all unit ids match an available unit for the company" do
      uniq_unit_ids = [unit1.id, unit2.id]
      available_units = [available_unit_1, available_unit_2]
      expect { instance.send(:validate_squad_units_available, uniq_unit_ids, available_units, company.id) }.
        not_to raise_error
    end

    it "fails when not unit ids match an available unit for the company" do
      uniq_unit_ids = [unit1.id, unit2.id, unit3.id]
      available_units = [available_unit_1, available_unit_2]
      expect { instance.send(:validate_squad_units_available, uniq_unit_ids, available_units, company.id) }.
        to raise_error(CompanyService::CompanyUpdateValidationError, "Found unavailable unit ids [#{unit3.id}] for the company #{company.id}")
    end
  end

  describe "#build_empty_tab_index_pop" do
    it "builds a hash with tab categories as keys" do
      result = instance.send(:build_empty_tab_index_pop)
      expect(result.keys).to match_array(Squad.tab_categories.values)
    end
    it "builds a hash where every value is an array of 8 zeros" do
      result = instance.send(:build_empty_tab_index_pop)
      expect(result.values.select { |e| e != Array.new(8, 0) }.size).to eq 0
    end
  end

  describe "#calculate_squad_resources" do
    let(:company) { create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset }
    let(:available_unit_1) { create :available_unit, company: company, unit: unit1, man: 100, mun: 0, fuel: 40, pop: 2 }
    let(:available_unit_2) { create :available_unit, company: company, unit: unit2, man: 400, mun: 130, fuel: 0, pop: 8 }
    let(:squads) { [{ unit_id: unit1.id, available_unit_id: available_unit_1.id, tab: "core", index: 0 },
                    { unit_id: unit1.id, available_unit_id: available_unit_1.id, tab: "core", index: 0 },
                    { unit_id: unit2.id, available_unit_id: available_unit_2.id, tab: "infantry", index: 1 },
                    { unit_id: unit2.id, available_unit_id: available_unit_2.id, tab: "infantry", index: 2 }] }
    let(:available_units_by_id) { { available_unit_1.id => available_unit_1, available_unit_2.id => available_unit_2 } }
    let(:available_upgrades_by_id) { {} }
    let(:platoon_pop_by_tab_and_index) { { "core": [0, 0, 0], "infantry": [0, 0, 0] }.with_indifferent_access }

    subject { instance.send(:calculate_squad_resources, squads, available_units_by_id, available_upgrades_by_id, platoon_pop_by_tab_and_index) }
    it "returns the correct resources" do
      man, mun, fuel, pop = subject
      expect(man).to eq(1000)
      expect(mun).to eq(260)
      expect(fuel).to eq(80)
      expect(pop).to eq(20)
    end

    it "sets the correct platoon pop" do
      subject
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

  describe "#get_total_available_resources" do
    let(:starting_man) { 5000 }
    let(:starting_mun) { 2000 }
    let(:starting_fuel) { 1400 }
    let(:ruleset) { create :ruleset, starting_man: starting_man, starting_mun: starting_mun, starting_fuel: starting_fuel }
    it "returns the correct resources" do
      man, mun, fuel = instance.send(:get_total_available_resources, ruleset)
      expect(man).to eq starting_man
      expect(mun).to eq starting_mun
      expect(fuel).to eq starting_fuel
    end
  end

  describe "#calculate_remaining_resources" do
    let(:ruleset) { create :ruleset, starting_man: 5000, starting_mun: 2000, starting_fuel: 1400 }

    it "returns resources remaining when the remaining resources are > 0" do
      man, mun, fuel = instance.send(:calculate_remaining_resources, ruleset, 4500, 1200, 1400)
      expect(man).to eq 500
      expect(mun).to eq 800
      expect(fuel).to eq 0
    end

    it "raises an error when one or more resource remaining is less than 0" do
      expect { instance.send(:calculate_remaining_resources, ruleset, 5500, 1200, 1400) }.
        to raise_error(CompanyService::CompanyUpdateValidationError,
                       "Invalid squad update, negative resource balance found: -500 manpower, 800 munitions, 0 fuel")
    end
  end

  describe "#validate_platoon_pop" do
    it "passes when all platoons have valid pop" do
      platoon_pop_by_tab_and_index = { "core": [0, 10, 0], "infantry": [12, 12, 8] }
      expect { instance.send(:validate_platoon_pop, platoon_pop_by_tab_and_index) }.
        not_to raise_error
    end

    it "fails when a platoon has pop greater than zero but less than the minimum" do
      platoon_pop_by_tab_and_index = { "core": [1, 10, 0], "infantry": [12, 12, 8] }
      expect { instance.send(:validate_platoon_pop, platoon_pop_by_tab_and_index) }.
        to raise_error(CompanyService::CompanyUpdateValidationError,
                       "Platoon at [core 0] has 1 pop, must be between 7 and 25, inclusive")
    end

    it "fails when a platoon has pop greater than the maximum" do
      platoon_pop_by_tab_and_index = { "core": [0, 10, 0], "infantry": [12, 27, 8] }
      expect { instance.send(:validate_platoon_pop, platoon_pop_by_tab_and_index) }.
        to raise_error(CompanyService::CompanyUpdateValidationError,
                       "Platoon at [infantry 1] has 27 pop, must be between 7 and 25, inclusive")
    end
  end

  describe "#build_available_unit_deltas" do
    let(:company) { create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset }
    let(:available_unit_1) { create :available_unit, company: company, unit: unit1, available: 1 }
    let(:available_unit_2) { create :available_unit, company: company, unit: unit2, available: 1 }
    let(:available_unit_3) { create :available_unit, company: company, unit: unit3, available: 0 }
    let(:squad1) { create :squad, company: company, available_unit: available_unit_1, tab_category: "core", category_position: 0 }
    let(:squad2) { create :squad, company: company, available_unit: available_unit_1, tab_category: "core", category_position: 0 }
    let(:squad3) { create :squad, company: company, available_unit: available_unit_2, tab_category: "infantry", category_position: 0 }
    let(:squad4) { create :squad, company: company, available_unit: available_unit_3, tab_category: "infantry", category_position: 1 }
    let(:existing_squads_by_available_unit_id) { { available_unit_1.id => [squad1, squad2], available_unit_2.id => [squad3], available_unit_3.id => [squad4] } }
    let(:payload_squad_by_available_unit_id) { { available_unit_1.id => [{ unit_id: unit1.id, available_unit_id: available_unit_1.id, tab: "core", index: 0 },
                                                                         { unit_id: unit1.id, available_unit_id: available_unit_1.id, tab: "core", index: 0 }],
                                                 available_unit_2.id => [{ unit_id: unit2.id, available_unit_id: available_unit_2.id, tab: "infantry", index: 1 },
                                                                         { unit_id: unit2.id, available_unit_id: available_unit_2.id, tab: "infantry", index: 2 }] } }
    let(:available_units_by_id) { { available_unit_1.id => available_unit_1, available_unit_2.id => available_unit_2, available_unit_3.id => available_unit_3 } }

    it "builds the correct availability changes hash for only units in the payload squads" do
      available_changes = instance.send(:build_available_unit_deltas, company, payload_squad_by_available_unit_id, existing_squads_by_available_unit_id, available_units_by_id)
      expect(available_changes.size).to eq 2
      expect(available_changes.keys).to match_array([available_unit_1.id, available_unit_2.id])
      expect(available_changes[available_unit_1.id]).to eq 0
      expect(available_changes[available_unit_2.id]).to eq -1
    end

    context "when there is insufficient availability for a unit" do
      before do
        available_unit_2.update!(available: 0)
      end

      it "raises an error" do
        expect { instance.send(:build_available_unit_deltas, company, payload_squad_by_available_unit_id, existing_squads_by_available_unit_id, available_units_by_id) }.
          to raise_error(CompanyService::CompanyUpdateValidationError,
                         "Insufficient availability to create squads for available unit #{available_unit_2.id} in company #{company.id}: Existing count 1, payload count 2, available number 0")
      end
    end
  end

  describe "#add_existing_squads_to_remove" do
    let(:company) { create :company, player: player, faction: faction, doctrine: doctrine, ruleset: ruleset }
    let(:available_unit_1) { create :available_unit, company: company, unit: unit1, available: 1 }
    let(:available_unit_2) { create :available_unit, company: company, unit: unit2, available: 1 }
    let(:available_unit_3) { create :available_unit, company: company, unit: unit3, available: 0 }
    let(:squad1) { create :squad, company: company, available_unit: available_unit_1, tab_category: "core", category_position: 0 }
    let(:squad2) { create :squad, company: company, available_unit: available_unit_1, tab_category: "core", category_position: 0 }
    let(:squad3) { create :squad, company: company, available_unit: available_unit_2, tab_category: "infantry", category_position: 0 }
    let(:squad4) { create :squad, company: company, available_unit: available_unit_3, tab_category: "infantry", category_position: 1 }
    let(:existing_squads_by_available_unit_id) { { available_unit_1.id => [squad1, squad2], available_unit_2.id => [squad3], available_unit_3.id => [squad4] } }
    let(:available_changes) { { available_unit_1.id => -1, available_unit_2.id => 0 } }

    it "adds the existing squad to remove availability to available changes" do
      instance.send(:add_existing_squads_to_remove, existing_squads_by_available_unit_id, available_changes)
      expect(available_changes.size).to eq 3
      expect(available_changes.keys).to match_array([available_unit_1.id, available_unit_2.id, available_unit_3.id])
      expect(available_changes[available_unit_3.id]).to eq 1
    end
  end
end
