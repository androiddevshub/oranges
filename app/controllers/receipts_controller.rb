class ReceiptsController < ApplicationController
  # before_action :find_order, only: [:create]

    def create
        @order = Order.find(params[:order_id])
        @receipt = Receipt.new(receipt_params)
        @receipt.order = @order
        @receipt.tprice = (@receipt.kilos * @receipt.ppfruit)
        addorderprice
        if @receipt.save
          redirect_to order_path(@order)
          else
           render :new
        end
      end

    def addorderprice
      @order.price += @receipt.tprice
      @order.client.employee.credit += @receipt.tprice * (0.10)
    end

    def discountorderprice
      @receipt.order.price -= @receipt.tprice
      @receipt.order.client.employee.credit -= @receipt.tprice * (0.10)
      @receipt.order.save
      @receipt.order.client.save
    end

      # DELETE /orders/1 FUCKING WORK ON THIS CAUSE IT DOESNT WORK- PARAMS CANNOT FIND ID BLABLABLA

    def destroy
      @receipt = Receipt.find(params[:id])
      discountorderprice
      
      @receipt.destroy
      redirect_to order_path(@receipt.order)
    end

    
      private
    
      def receipt_params
        params.require(:receipt).permit(:kilos, :fruit, :ppfruit, :tprice, :receipt_id, orders_attributes: [:order_id, :price], clients_attributes:[:name, employees_attributes: [:employee_id, :credit]] )
      end

 
      def find_order
        @order = Order.find(params[:id])
      end

      def find_employee
        @employee = Employee.find(params[:id])
      end
end
