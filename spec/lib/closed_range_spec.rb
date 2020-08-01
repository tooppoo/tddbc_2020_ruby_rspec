# - rangeクラス
#   - [x] 下端点、上端点を持つ
# - [x] 文字列表現を返す
#   - [x] 下端点 3, 上端点 8 の整数閉区間の文字列表記は "[3,8]"

# - [x] 上端点とか端点が一致する閉区間は作ることができる
#   - [ ] describeの記述
#   - [ ] テストの分類
# - [x] 上端点より下端点が大きい閉区間を作ることはできない
# - [x] 整数の閉区間は指定した整数を含むかどうかを判定する
#  - [x] 下端点 3, 上端点 8 の整数閉区間は4を含む
#  - [x] 下端点 3, 上端点 8 の整数閉区間は2を含まない
# - [x] 別の閉区間と等価かどうかを判定できる
# - [ ] 完全に含まれるかどうかを判定できる
# - [ ] 小数を渡されるとエラーにする
# - [ ] context を使う
# - [ ] raise error のテストでletが使えない

describe ClosedRange do
  let(:closed_range) { ClosedRange.new(lower: lower, upper: upper) }

  describe '定義に沿った閉区間' do
    describe '文字列表記を返す' do
      describe '下端点 != 上端点' do
        let(:lower) { 3 }
        let(:upper) { 8 }
        it '下端点 3, 上端点 8 の整数閉区間の文字列表記は "[3,8]"' do
          expect(closed_range.to_s).to eq "[3,8]"
        end
      end
      describe '下端点 == 上端点' do
        let(:lower) { 4 }
        let(:upper) { 4 }
        it '下端点 4, 上端点 4 の整数閉区間の文字列表記は "[4,4]"' do
          expect(closed_range.to_s).to eq "[4,4]"
        end
      end
    end

    describe '整数の閉区間に整数pは含まれるか' do
      let(:lower) { 3 }
      let(:upper) { 8 }
      subject { closed_range.include?(num) }

      describe 'p < 下端点' do
        let(:num) { 2 }
        it '下端点 3, 上端点 8 の整数閉区間は2を含まない' do
          expect(subject).to eq false
        end
      end
      describe '下端点 == p' do
        let(:num) { 3 }
        it '下端点 3, 上端点 8 の整数閉区間は3を含む' do
          expect(subject).to eq true
        end
      end
      describe '下端点 < p < 上端点' do
        let(:num) { 4 }
        it '下端点 3, 上端点 8 の整数閉区間は4を含む' do
          expect(subject).to eq true
        end
      end
      describe 'p == 上端点' do
        let(:num) { 8 }
        it '下端点 3, 上端点 8 の整数閉区間は8を含む' do
          expect(subject).to eq true
        end
      end
      describe '上端点 < p' do
        let(:num) { 9 }
        it '下端点 3, 上端点 8 の整数閉区間は9を含まない' do
          expect(subject).to eq false
        end
      end
    end

    describe '別の閉区間と等価かどうかを判定する' do
      let(:closed_range1) { ClosedRange.new(lower: 3, upper: 8) }
      let(:closed_range2) { ClosedRange.new(lower: lower, upper: upper) }

      subject { closed_range1 == closed_range2 }

      describe '下端点と上端点は等しい' do
        let(:lower) { 3 }
        let(:upper) { 8 }
        it '閉区間[3,8]と閉区間[3,8]は等しい' do
          expect(subject).to eq true
        end
      end
      describe '下端点は等しいが、上端点は等しくない' do
        let(:lower) { 3 }
        let(:upper) { 9 }
        it '閉区間[3,8]と閉区間[3,9]は等しくない' do
          expect(subject).to eq false
        end
      end
      describe '下端点は等しくないが、上端点は等しい' do
        let(:lower) { 4 }
        let(:upper) { 8 }
        it '閉区間[3,8]と閉区間[4,8]は等しくない' do
          expect(subject).to eq false
        end
      end
      describe '下端点と上端点がどちらも等しくない' do
        let(:lower) { 4 }
        let(:upper) { 5 }
        it '閉区間[3,8]と閉区間[4,5]は等しくない' do
          expect(subject).to eq false
        end
      end
    end

    describe '別の閉区間を完全に含むかどうかを判定する' do
      it '閉区間[3,8]は閉区間[4,7]を完全に含む' do
        expect(ClosedRange.new(lower: 3, upper: 8).contain?(ClosedRange.new(lower: 4, upper: 7))).to eq true
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
