# app/services/record_pdf_generator.rb
class RecordPdfGenerator
    def initialize(record)
      @record = record
    end
  
    def generate
      Prawn::Document.new do |pdf|
        pdf.text "Record ID: #{@record.id}", size: 30, style: :bold
        pdf.move_down 20
  
        # Details
        pdf.text "Customer ID: #{@record.customer_id}"
        pdf.text "Cashier ID: #{@record.cashier_id}"
        pdf.text "Total Amount: #{@record.total_amount}"
        pdf.text "Payment Method: #{@record.payment_method}"
        pdf.text "Date: #{@record.created_at.strftime('%d/%m/%Y')}"
        pdf.text "Address: #{@record.address}"
        pdf.text "Postal Code: #{@record.postal_code}"
        
        pdf.move_down 20
  
        # Medicines List
        pdf.text "Medicine Details", size: 18, style: :bold
        pdf.move_down 10
        pdf.table(medicine_data, header: true, row_colors: ['F0F0F0', 'FFFFFF'])
  
        # Footer
        pdf.move_down 30
        pdf.text "Generated by Pharma Site", align: :center
      end
    end
  
    private
  
    def medicine_data
      [['Medicine Name', 'Number of Tablets']] +
      @record.medicine_ids.map do |medicine|
        [medicine['name'], medicine['number_of_tablets']]
      end
    end
  end
  