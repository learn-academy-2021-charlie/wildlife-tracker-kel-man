json.date Time.zone.parse(@sighting.date.to_time.iso8601).utc
json.latitude @sighting.latitude
json.longitude @sighting.longitude
json.animal_id @sighting.animal_id
