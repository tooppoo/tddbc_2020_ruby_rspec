# - rangeクラス
#   - [x] 下端点、上端点を持つ
# - [x] 文字列表現を返す
#   - [x] 下端点 3, 上端点 8 の整数閉区間の文字列表記は "[3,8]"

# - [x] 上端点とか端点が一致する閉区間は作ることができる
#   - [ ] describeの記述
#   - [ ] テストの分類
# - [x] 上端点より下端点が大きい閉区間を作ることはできない
# - 整数の閉区間は指定した整数を含むかどうかを判定できる
# - 別の閉区間と等価かどうかを判定できる
# - 完全に含まれるかどうかを判定できる

describe ClosedRange do
  describe '定義に沿った閉区間' do
    describe '文字列表記を返す' do
      it '下端点 3, 上端点 8 の整数閉区間の文字列表記は "[3,8]"' do
        expect(ClosedRange.new(lower: 3, upper: 8).to_s).to eq "[3,8]"
      end
      it '下端点 4, 上端点 5 の整数閉区間の文字列表記は "[4,5]"' do
        expect(ClosedRange.new(lower: 4, upper: 5).to_s).to eq "[4,5]"
      end
      it '下端点 4, 上端点 4 の整数閉区間の文字列表記は "[4,4]"' do
        expect(ClosedRange.new(lower: 4, upper: 4).to_s).to eq "[4,4]"
      end
    end
  end

  describe '定義に沿わない閉区間' do
    describe '上端点より下端点が大きい閉区間を作ることはできない' do
      it '下端点 4, 上端点 3の閉区間を作ることができない' do
        expect { ClosedRange.new(lower: 4, upper: 3) }.to raise_error ClosedRange::InvalidClosedRangeError
      end
    end
  end
end
