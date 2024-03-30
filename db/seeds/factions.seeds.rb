after :rulesets do
  factions = []
  faction_restrictions = []
  CSV.foreach("db/seeds/factions.csv", headers: true) do |row|
    name = row["name"]
    display_name = row["display_name"]
    const_name = row["const_name"]
    internal_name = row["internal_name"]
    side = row["side"]
    race = row["race"]
    restriction_name = row["restriction_name"]
    restriction_description = row["restriction_description"]
    f = Faction.new(name: name, display_name: display_name, const_name: const_name,
                            internal_name: internal_name, side: side, race: race)
    factions << f
    faction_restrictions << Restriction.new(faction: f, name: restriction_name, description: restriction_description)
  end
  Faction.import! factions,
                  on_duplicate_key_update: {
                    conflict_target: [:name],
                    columns: [:display_name, :const_name, :internal_name, :side, :race]
                  }
  Restriction.import! faction_restrictions,
                      on_duplicate_key_update: {
                        conflict_target: [:faction_id],
                        index_predicate: "faction_id IS NOT NULL", # this is a partial index
                        columns: [:name, :description]
                      }
end
