require 'rails_helper'

RSpec.describe "Sightings", type: :request do
  let(:animal1){ Animal.create!({
    common_name: 'mouse',
    latin_name: 'mus musculus',
    kingdom: 'mammal'
  }) }
  let(:animal2){ Animal.create!({
    common_name: 'monitor lizard',
    latin_name: 'varanus',
    kingdom: 'reptile'
  }) }
  let(:animal3){ Animal.create!({
    common_name: 'bald eagle',
    latin_name: 'haliaeetus leucocephalus',
    kingdom: 'raptor'
  }) }
  let(:sighting){ Sighting.create!({
    latitude: 1235326,
    longitude: 12342352,
    date: Time.zone.parse(DateTime.now.iso8601).utc,
    animal_id: animal2.id
  }) }
  let(:sighting2){ Sighting.create!({
    latitude: 1925.32556,
    longitude: 93286.13234,
    date: Time.zone.parse(DateTime.now.iso8601).utc,
    animal_id: animal2.id
  }) }
  let(:sighting3){ Sighting.create!({
    latitude: 132,
    longitude: 0.2326,
    date: Time.zone.parse(DateTime.new(2001,2,3,4,5,6).iso8601).utc,
    animal_id: animal2.id
  }) }

  before do
    animal1
    animal2
    animal3
    sighting
    sighting2
    sighting3
  end

  describe 'create' do
    let(:date){ Time.zone.parse(DateTime.now.iso8601).utc }
    let(:latitude){ 104.3456 }
    let(:longitude){ 9993314.32634 }
    let(:request){ post '/sightings', params: {
      sighting: {
        date: date,
        latitude: latitude,
        longitude: longitude,
        animal_id: animal2.id,
      }
    } }
    let(:expected_response){ {
      'date' => date.to_time.iso8601[0..18]+'.000Z',
      'latitude' => latitude,
      'longitude' => longitude,
      'animal_id' => animal2.id,
    } }
    it 'creates a new sighting for animal2' do
      expect{ request }.to change{Sighting.count}.by (1)
      expect(JSON.parse(response.body)).to include expected_response
    end
  end

  describe 'update' do
    let(:new_lat){ 343251.62346 }
    let(:request){ patch "/sightings/#{sighting.id}", params: {
      sighting: {
        latitude: new_lat
      }
    } }
    let(:expected_response) { {
      'latitude' => new_lat,
      'longitude' => sighting.longitude,
      'date' => sighting.date,
      'animal_id' => sighting.animal_id
    } }
    it 'updates the latitude of the entry' do
      request
      expect(JSON.parse(response.body)).to include expected_response
      expect(sighting.reload.latitude).to eq new_lat
    end
  end

  describe 'destroy' do
    let(:request){ delete "/sightings/#{sighting.id}" }
    let(:expected_response){ {
      sightings: [sighting2, sighting3]
    }.to_json }
    it 'destroys sighting from the database' do
      expect{ request }.to change{ Sighting.count }.by ( -1 )
      expect(response.status).to eq 204
    end
  end

  describe 'index' do
    let(:request){ get "/sightings", params: {
      start_date: sighting.date,
      end_date: sighting2.date,
      }
    }
    let(:expected_response){ {
      'sightings' => [{
        'id' => sighting.id,
        'date' => sighting.date.to_time.iso8601[0..18]+'.000Z',
        'latitude' => sighting.latitude,
        'longitude' => sighting.longitude,
        'animal_id' => sighting.animal_id,
      }, {
        'id' => sighting2.id,
        'date' => sighting2.date.to_time.iso8601[0..18]+'.000Z',
        'latitude' => sighting2.latitude,
        'longitude' => sighting2.longitude,
        'animal_id' => sighting2.animal_id,
      }]
    } }
    it 'only returns sightings for the given time period' do
      request
      expect(JSON.parse(response.body)).to include expected_response
    end
  end
end
