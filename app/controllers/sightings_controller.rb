class SightingsController < ApplicationController
  def create
    @sighting = Sighting.create(sighting_params)
    render('show')
  end

  private
  def sighting_params
    params.require(:sighting).permit(:date, :latitude, :longitude, :animal_id)
  end
end
