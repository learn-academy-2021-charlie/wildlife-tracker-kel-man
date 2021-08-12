class AnimalsController < ApplicationController
  def index
    @animals = Animal.all
    render('index')
  end

  def show
    animal = Animal.find(params[:id])
    render json: animal
  end

  def create

  end

  def update

  end

  def destroy

  end
end
