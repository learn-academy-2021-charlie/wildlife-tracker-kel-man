json.sightings @sightings do |sighting|
  json.id sighting.id
  json.date sighting.date
  json.latitude sighting.latitude
  json.longitude sighting.longitude
  json.animal_id sighting.animal_id
end
