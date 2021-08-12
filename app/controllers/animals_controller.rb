class AnimalsController < ApplicationController
  def index
    @animals = Animal.all
    render('index')
  end

  def show
    @animal = Animal.find(params[:id])
    render('show')
  end

  def create

  end

  def update
    @animal = Animal.find(params[:id])
    if @animal
      @animal.update(animal_params)
      render('show')
    else
      head 404
    end
  end

  def destroy

  end

  private
  def animal_params
    params.require(:animal).permit(:common_name, :latin_name, :kingdom)
  end
end
