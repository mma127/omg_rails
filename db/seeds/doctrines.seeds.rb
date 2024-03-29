after :factions do
  require "csv"
  doctrines = []
  doctrine_restrictions = []
  factions_by_name = Faction.all.index_by(&:name); 0
  CSV.foreach("db/seeds/doctrines.csv", headers: true) do |row|
    name = row["name"]
    display_name = row["display_name"]
    const_name = row["const_name"]
    internal_name = row["internal_name"]
    faction_name = row["faction_name"]
    restriction_name = row["restriction_name"]
    restriction_description = row["restriction_description"]
    f = factions_by_name[faction_name]
    d = Doctrine.new(name: name, display_name: display_name, const_name: const_name,
                    internal_name: internal_name, faction: f)
    doctrines << d
    doctrine_restrictions << Restriction.new(doctrine: d, name: restriction_name, description: restriction_description)
  end
  Doctrine.import! doctrines,
                  on_duplicate_key_update: {
                    conflict_target: [:name],
                    columns: [:display_name, :const_name, :internal_name]
                  }
  Restriction.import! doctrine_restrictions,
                      on_duplicate_key_update: {
                        conflict_target: [:doctrine_id],
                        index_predicate: "doctrine_id IS NOT NULL", # this is a partial index
                        columns: [:name, :description]
                      }
end
