json.animals @animals do |animal|
  json.id animal.id
  json.common_name animal.common_name
  json.latin_name animal.latin_name
  json.kingdom animal.kingdom
end
