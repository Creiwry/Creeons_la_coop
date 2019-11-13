# frozen_string_literal: true

# Ressource for the members to get products from (vegetables...), and are managed by the 'Aprovisionnement/Commande' team
class ProductorsController < ApplicationController
  before_action :authenticate_member!
  before_action :set_authorized_productor, only: %i[show edit update destroy]

  def index
    @productors = Productor.includes :address, :avatar_attachment
  end

  def new
    @productor = authorize Productor.new

    # address form generator
    @productor.build_address
  end

  def create
    @productor = authorize Productor.new(permitted_params)
    if @productor.save
      flash[:notice] = "Le producteur a bien été créé"
      redirect_to @productor
    else
      flash[:error] = "Une erreur est survenue, veuillez recommencer l'opération. Est-ce que ce producteur existe déjà?"
      redirect_to new_productor_path
    end
  end

  def show; end

  def edit
    @productor.build_address if @productor.address.nil?
  end

  def update
    if @productor.update(permitted_params)
      flash[:notice] = "Le producteur a bien été mis à jour"
      redirect_to @productor
    else
      flash[:error] = "Une erreur est survenue, veuillez recommencer l'opération"
      redirect_to edit_productor_path(@productor.id)
    end
  end

  def destroy
    if @productor.destroy
      flash[:notice] = "Le producteur a été supprimé"
    else
      flash[:error] = "Opération échouée, une erreur est survenue"
    end
    redirect_to productors_path
  end

  private

  def permitted_params
    params.require(:productor).permit(:name, :description, :local,
                                      :phone_number, :website_url, :avatar,
                                      catalogs: [],
                                      address_attributes: [
                                        :id, :postal_code, :city, :street_name_1,
                                        :street_name_2, coordinates: []
                                      ])
  end

  def set_authorized_productor
    @productor = authorize Productor.find(params[:id])
  end
end
