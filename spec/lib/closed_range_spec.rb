describe ClosedRange do
  describe '文字列表記を返す' do
    it '下端点 3, 上端点 8 の整数閉区間の文字列表記は "[3,8]"' do
      expect(ClosedRange.new).to eq "[3,8]"
    end
  end
end
