# frozen_string_literal: true

module Admin
  class MerchantsController < BaseController
    def index
      @merchants = Merchant.all.order(:name)
    end

    def edit
      @merchant = Merchant.find(params[:id])
      @errors = {}
    end

    def update
      @merchant = Merchant.find(params[:id])

      result = UpdateMerchant.new.call(
        merchant: @merchant,
        attrs: params.require(:merchant).to_unsafe_h
      )

      if result.success?
        redirect_to admin_merchants_path, notice: 'Merchant has been updated'
      else
        @errors = result.failure
        render :edit
      end
    end

    def destroy
      @merchant = Merchant.find(params[:id])

      if @merchant.destroy
        flash[:notice] = 'Merchant has been deleted'
      else
        flash[:error] = 'Merchant can not be deleted'
      end

      redirect_to admin_merchants_path
    end
  end
end
