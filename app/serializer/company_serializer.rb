class CompanySerializer < ApplicationSerializer
  attributes :name, :player_id, :doctrine_id, :faction_id,
             :man, :mun, :fuel, :pop, :vps_earned, :side
end
