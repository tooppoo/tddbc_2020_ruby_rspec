describe ClosedRange do
  describe '文字列表記を返す' do
    it '下端点 3, 上端点 8 の整数閉区間の文字列表記は "[3,8]"' do
      expect(ClosedRange.new(lower: 3, upper: 8).to_s).to eq "[3,8]"
    end
    it '下端点 4, 上端点 5 の整数閉区間の文字列表記は "[4,5]"' do
      expect(ClosedRange.new(lower: 4, upper: 5).to_s).to eq "[4,5]"
    end
  end
end
