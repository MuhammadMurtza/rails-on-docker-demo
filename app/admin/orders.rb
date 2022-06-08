ActiveAdmin.register Order do
  permit_params :sales_order_number, :vendor_purchase_order_number, :shipping_method, :shipping_account_number, :shipping_details, :vendor, :status, :test_order, :notes, :netsuite_updated_at, :vendor_updated_at

  remove_filter :packing_lists, :shipping_labels, :addresses, :versions, :line_items

  form do |f|
    inputs do
      input :sales_order_number
      input :vendor_purchase_order_number
      input :shipping_method
      input :shipping_account_number
      input :shipping_details
      input :vendor
      input :status
      input :test_order
      input :notes
      input :netsuite_updated_at
      input :vendor_updated_at

      f.submit
    end
  end

  show do
    default_main_content
    panel 'LINKS' do
      link_to 'Submit To MWW', submit_order_path(order)
    end
  end

  sidebar 'Orders', only: [:show, :edit] do
    ul do
      li link_to 'Line Items',    admin_order_line_items_path(resource)
      li link_to 'Addresses', admin_order_addresses_path(resource)
      li link_to 'Shipping Label', admin_order_shipping_labels_path(resource)
      li link_to 'Packing List', admin_order_packing_lists_path(resource)
    end
  end

  controller do
    def create
      order = Order.new(permitted_params[:order])
      order.notes = permitted_params.dig(:order, :notes)&.split

      if order.save
        redirect_to admin_order_path(order), notice: 'Order created successfully'
      else
        redirect_to new_admin_order_path, alert: order.errors
      end
    end

    def submit_order
      submission_details = MWWService::SubmitOrder.call(order)

      if submission_details[:status]
        redirect_to admin_order_path(order), notice: submission_details[:message]
      else
        redirect_to admin_order_path(order), alert: submission_details[:message]
      end
    end

    private

    def order
      @_order ||= Order.find(params[:id])
    end
  end
end