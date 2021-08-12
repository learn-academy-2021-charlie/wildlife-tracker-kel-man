json.sightings @sightings do |sighting|
  json.animal_id sighting.animal_id
  json.latitude sighting.latitude
  json.longitude sighting.longitude
  json.date sighting.date
end
