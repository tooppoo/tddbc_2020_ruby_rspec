# - rangeクラス
#   - [x] 下端点、上端点を持つ
# - [x] 文字列表現を返す
#   - [x] 下端点 3, 上端点 8 の整数閉区間の文字列表記は "[3,8]"

# - [x] 上端点とか端点が一致する閉区間は作ることができる
#   - [x] describeの記述
#   - [x] テストの分類
# - [x] 上端点より下端点が大きい閉区間を作ることはできない
# - [x] 整数の閉区間は指定した整数を含むかどうかを判定する
#  - [x] 下端点 3, 上端点 8 の整数閉区間は4を含む
#  - [x] 下端点 3, 上端点 8 の整数閉区間は2を含まない
# - [x] 別の閉区間と等価かどうかを判定できる
# - [x] 完全に含まれるかどうかを判定できる
# - [x] context を使う
# - [x] raise error のテストでletが使えない
# - [x] to_s とオブジェクト生成のバリエーションでテスト分離

describe ClosedRange do
  describe '閉区間の生成' do
    subject { -> { ClosedRange.new(lower: lower, upper: upper) } }

    describe '生成できる' do
      context '下端点 < 上端点' do
        let(:lower) { 3 }
        let(:upper) { 8 }
        it { is_expected.not_to raise_error }
      end
      context '下端点 == 上端点' do
        let(:lower) { 4 }
        let(:upper) { 4 }
        it { is_expected.not_to raise_error }
      end
    end
    describe '生成できない' do
      context '下端点 > 上端点' do
        let(:lower) { 4 }
        let(:upper) { 3 }
        it { is_expected.to raise_error ClosedRange::InvalidClosedRangeError }
      end
    end
  end

  let(:closed_range) { ClosedRange.new(lower: lower, upper: upper) }

  describe '文字列表記を返す' do
    context '閉区間(3, 8)' do
      let(:lower) { 3 }
      let(:upper) { 8 }

      it '[3,8]' do
        expect(closed_range.to_s).to eq '[3,8]'
      end
    end
  end

  describe '閉区間aに整数pは含まれるか' do
    subject { closed_range.include?(p) }

    context 'a: [3,8]' do
      let(:lower) { 3 }
      let(:upper) { 8 }

      where(:case_name, :p, :expected) do
        [
          ['p < 下端点', 2, false],
          ['下端点 == p', 3, true],
          ['下端点 < p < 上端点', 4, true],
          ['p == 上端点', 8, true],
          ['上端点 < p', 9, false],
        ]
      end

      with_them do
        context "p: #{params[:p]}" do
          it { is_expected.to eq expected }
        end
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

  describe '閉区間aが閉区間bを完全に含むかどうかを判定する' do
    context 'a = [3,8]' do
      let(:a) { ClosedRange.new(lower: 3, upper: 8) }

      subject { a.contain?(b) }

      context 'bの下端点 < aの下端点' do
        where(:case_name, :b) do
          [
            ['bの上端点 < aの下端点', ClosedRange.new(lower: 1, upper: 2)],
            ['bの上端点 = aの下端点', ClosedRange.new(lower: 1, upper: 3)],
            ['aの下端点 < bの上端点 < aの上端点', ClosedRange.new(lower: 1, upper: 4)],
            ['bの上端点 = aの上端点', ClosedRange.new(lower: 1, upper: 8)],
            ['aの上端点 < bの上端点', ClosedRange.new(lower: 1, upper: 9)],
          ]
        end

        with_them do
          context "b: #{params[:b]}" do
            it { is_expected.to eq false }
          end
        end
      end
      context 'bの下端点 = aの下端点' do
        where(:case_name, :b, :expected) do
          [
            ['bの上端点 < aの上端点', ClosedRange.new(lower: 3, upper: 4), true],
            ['bの上端点 = aの上端点', ClosedRange.new(lower: 3, upper: 8), true],
            ['aの上端点 < bの上端点', ClosedRange.new(lower: 3, upper: 9), false],
          ]
        end

        with_them do
          context "b: #{params[:b]}" do
            it { is_expected.to eq expected }
          end
        end
      end
      context 'aの下端点 < bの下端点 < aの上端点' do
        where(:case_name, :b, :expected) do
          [
            ["bの上端点 < aの上端点", ClosedRange.new(lower: 5, upper: 6), true],
            ["bの上端点 = aの上端点", ClosedRange.new(lower: 5, upper: 8), true],
            ["aの上端点 < bの上端点", ClosedRange.new(lower: 5, upper: 9), false],
          ]
        end

        with_them do
          context "b: #{params[:b]}" do
            it { is_expected.to eq expected }
          end
        end
      end
      context 'aの上端点 = bの下端点' do
        where(:case_name, :b, :expected) do
          [
            ['bの上端点 = aの上端点', ClosedRange.new(lower: 8, upper: 8), true],
            ['aの上端点 < bの上端点', ClosedRange.new(lower: 8, upper: 9), false],
          ]
        end

        with_them do
          context "b: #{params[:b]}" do
            it { is_expected.to eq expected }
          end
        end
      end
      context 'aの上端点 < bの下端点' do
        where(:b) do
          [
            [ClosedRange.new(lower: 9, upper: 10)],
          ]
        end

        with_them do
          it { is_expected.to eq false }
        end
      end
    end
  end
end
