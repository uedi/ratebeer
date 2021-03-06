class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :confirm_membership]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @clubs = BeerClub.all
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    if current_user.nil?
      redirect_to :back, notice: "Please signin first"
    elsif BeerClub.find(params[:membership][:beer_club_id]).members.include?(current_user)
      redirect_to :back, notice: "You're already a member of the club"
    else  
      @membership = Membership.new beer_club_id:params[:membership][:beer_club_id], user_id:current_user.id

      respond_to do |format|
        if @membership.save
          format.html { redirect_to @membership.beer_club, notice: "#{current_user.username}, welcome to the club!" }
          format.json { render :show, status: :created, location: @membership }
        else
          format.html { render :new }
          format.json { render json: @membership.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership = current_user.memberships.find_by(beer_club_id: params[:membership][:beer_club_id])
    club_name = BeerClub.find_by(id: @membership.beer_club_id).name
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to user_path(current_user), notice: "Membership in #{club_name} ended." }
      format.json { head :no_content }
    end
  end
  
  def confirm_membership
    @beerclub = BeerClub.find_by(id: @membership.beer_club_id)
    if @beerclub.members.include?(current_user)
      @membership.confirmed = true
      @membership.save
      redirect_to :back, notice: "membership confirmed"
    else
      redirect_to :back, notice: "you must be a member to confirm"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:beer_club_id, :user_id)
    end
end
