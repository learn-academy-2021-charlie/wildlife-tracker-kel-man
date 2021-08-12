class SightingsController < ApplicationController
  def create
    @sighting = Sighting.create(sighting_params)
    render('show')
  end

  def update
    @sighting = Sighting.find(params[:id])
    if @sighting
      @sighting.update(sighting_params)
      render('show')
    else
      head 404
    end
  end

  def destroy
    @sighting = Sighting.find(params[:id])
    if @sighting
      @sighting.destroy
      head 204
    else
      head 404
    end
  end

  private
  def sighting_params
    params.require(:sighting).permit(:date, :latitude, :longitude, :animal_id)
  end
end
