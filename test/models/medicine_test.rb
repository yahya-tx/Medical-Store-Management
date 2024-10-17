require "test_helper"

class MedicineTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  self.use_transactional_tests = false

  test "should not save medicine without name" do
    medicine = Medicine.new 
    assert_not medicine.save
  end
end
