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
# - [x] 閉区間に含まれる整数を列挙できる
# - [ ] 閉区間同士の重複部分を取得できる
#   - [x] 重複がある場合
#   - [ ] 重複がない場合

describe ClosedRange do
  describe '閉区間の生成' do
    subject { -> { ClosedRange.new(lower: lower, upper: upper) } }

    describe '生成できる' do
      where(:case_name, :lower, :upper) do
        [
          ['下端点 < 上端点', 3, 8],
          ['下端点 == 上端点', 4, 4],
        ]
      end

      with_them do
        context "[#{params[:lower]},#{params[:upper]}]" do
          it { is_expected.not_to raise_error }
        end
      end
    end
    describe '生成できない' do
      context '上端点 < 下端点' do
        context "[4,3]" do
          let(:lower) { 4 }
          let(:upper) { 3 }
          it { is_expected.to raise_error ClosedRange::InvalidClosedRangeError }
        end
      end
    end
  end

  let(:closed_range) { ClosedRange.new(lower: lower, upper: upper) }

  describe '文字列表記を返す' do
    subject { closed_range.to_s }

    context '[3,8]' do
      let(:lower) { 3 }
      let(:upper) { 8 }

      it { is_expected.to eq '[3,8]' }
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

  describe '閉区間aと閉区間bは等価かどうかを判定する' do
    subject { a == b }

    context 'a: [3,8]' do
      let(:a) { ClosedRange.new(lower: 3, upper: 8) }
      let(:b) { ClosedRange.new(lower: lower, upper: upper) }

      where(:case_name, :lower, :upper, :expected) do
        [
          ['下端点と上端点がいずれも等しい', 3, 8, true],
          ['下端点は等しいが、上端点は等しくない', 3, 9, false],
          ['下端点は等しくないが、上端点は等しい', 4, 8, false],
          ['下端点と上端点がどちらも等しくない', 4, 5, false],
        ]
      end

      with_them do
        context "b: [#{params[:lower]},#{params[:upper]}]" do
          it { is_expected.to eq expected}
        end
      end

      context '空範囲' do
        context 'b: empty' do
          let(:b) { ClosedRange.empty }

          it { is_expected.to be false }
        end
      end
    end
  end

  describe '閉区間aが閉区間bを完全に含むかどうかを判定する' do
    subject { a.contain?(b) }

    context 'a: [3,8]' do
      let(:a) { ClosedRange.new(lower: 3, upper: 8) }
      let(:b) { ClosedRange.new(lower: lower, upper: upper) }

      context 'bの下端点 < aの下端点' do
        where(:case_name, :lower, :upper) do
          [
            ['bの上端点 < aの下端点', 1, 2],
            ['bの上端点 = aの下端点', 1, 3],
            ['aの下端点 < bの上端点 < aの上端点', 1, 4],
            ['bの上端点 = aの上端点', 1, 8],
            ['aの上端点 < bの上端点', 1, 9],
          ]
        end

        with_them do
          context "b: [#{params[:lower]},#{params[:upper]}]" do
            it { is_expected.to eq false }
          end
        end
      end
      context 'bの下端点 = aの下端点' do
        where(:case_name, :lower, :upper, :expected) do
          [
            ['bの上端点 < aの上端点', 3, 4, true],
            ['bの上端点 = aの上端点', 3, 8, true],
            ['aの上端点 < bの上端点', 3, 9, false],
          ]
        end

        with_them do
          context "b: [#{params[:lower]},#{params[:upper]}]" do
            it { is_expected.to eq expected }
          end
        end
      end
      context 'aの下端点 < bの下端点 < aの上端点' do
        where(:case_name, :lower, :upper, :expected) do
          [
            ["bの上端点 < aの上端点", 5, 6, true],
            ["bの上端点 = aの上端点", 5, 8, true],
            ["aの上端点 < bの上端点", 5, 9, false],
          ]
        end

        with_them do
          context "b: [#{params[:lower]},#{params[:upper]}]" do
            it { is_expected.to eq expected }
          end
        end
      end
      context 'aの上端点 = bの下端点' do
        where(:case_name, :lower, :upper, :expected) do
          [
            ['bの上端点 = aの上端点', 8, 8, true],
            ['aの上端点 < bの上端点', 8, 9, false],
          ]
        end

        with_them do
          context "b: [#{params[:lower]},#{params[:upper]}]" do
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
      context '空範囲' do
        let(:b) { ClosedRange.empty }

        context 'b: empty' do
          it { is_expected.to be true }
        end
      end
    end
  end

  describe '閉区間aに含まれる整数を列挙できる' do
    subject { closed_range.to_a }
    where(:case_name, :lower, :upper, :expected) do
      [
        ['下端点 == 上端点', 1, 1, [1]],
        ['下端点 < 上端点', 1, 4, [1, 2, 3, 4]],
      ]
    end

    with_them do
      context "a: [#{params[:lower]},#{params[:upper]}]" do
        it { is_expected.to eq expected }
      end
    end
  end

  describe '閉区間aと閉区間bの重複を取れる' do
    subject { a * b }

    context 'a: [3,8]' do
      let(:a) { ClosedRange.new(lower: 3, upper: 8) }
      let(:b) { ClosedRange.new(lower: lower, upper: upper ) }
      let(:expected) { ClosedRange.new(lower: expected_lower, upper: expected_upper ) }

      context 'bの下端点 < aの下端点' do
        let(:lower) { 1 }
        context 'bの上端点 < aの下端点' do
          context 'b: [1,2]' do
            let(:upper) { 2 }

            it { is_expected.to eq ClosedRange.empty }
          end
        end

        where(:case_name, :upper, :expected_lower, :expected_upper) do
          [
            ['bの上端点 = aの下端点', 3, 3, 3],
            ['aの下端点 < bの上端点 < aの上端点', 7, 3, 7],
            ['aの上端点 = bの上端点', 8, 3, 8],
            ['aの上端点 < bの上端点', 9, 3, 8],
          ]
        end

        with_them do
          context "b: [2,#{params[:upper]}]" do
            it { is_expected.to eq expected }
          end
        end
      end
      context 'aの下端点 = bの下端点' do
        let(:lower) { 3 }

        where(:case_name, :upper, :expected_lower, :expected_upper) do
          [
            ['bの上端点 < aの上端点', 7, 3, 7],
            ['aの上端点 = bの上端点', 8, 3, 8],
            ['aの上端点 < bの上端点', 9, 3, 8],
          ]
        end

        with_them do
          context "b: [3,#{params[:upper]}]" do
            it { is_expected.to eq expected }
          end
        end
      end
      context 'aの下端点 < bの下端点 < aの上端点' do
        let(:lower) { 4 }

        where(:case_name, :upper, :expected_lower, :expected_upper) do
          [
            ['bの上端点 < aの上端点', 7, 4, 7],
            ['aの上端点 = bの上端点', 8, 4, 8],
            ['aの上端点 < bの上端点', 9, 4, 8],
          ]
        end

        with_them do
          context "b: [4,#{params[:upper]}]" do
            it { is_expected.to eq expected }
          end
        end
      end
      context 'bの下端点 = aの上端点' do
        let(:lower) { 8 }

        where(:case_name, :upper, :expected_lower, :expected_upper) do
          [
            ['aの上端点 = bの上端点', 8, 8, 8],
            ['aの上端点 < bの上端点', 9, 8, 8],
          ]
        end

        with_them do
          context "b: [8,#{params[:upper]}]" do
            it { is_expected.to eq expected }
          end
        end
      end
      context 'aの上端点 < bの下端点' do
        let(:lower) { 9 }
        let(:upper) { 10 }

        context 'b: [9,10]' do
          it { is_expected.to eq ClosedRange.empty }
        end
      end
      context '空範囲' do
        context 'b: empty' do
          let(:b) { ClosedRange.empty }

          it { is_expected.to eq ClosedRange.empty }
        end
      end
    end
  end
end

describe ClosedRange::Empty do
  let(:empty) { ClosedRange.empty }

  describe '文字列表現を返す' do
    it 'empty' do
      expect(empty.to_s).to eq 'empty'
    end
  end
  describe '整数の閉区間は指定した整数を含むかどうかを判定する' do
    it false do
      expect(empty.include?(3)).to be false
    end
  end
  describe '別の閉区間と等価かどうかを判定できる' do
    subject { empty == other }
    where(:case_name, :other, :expected) do
      [
        ['範囲有り', ClosedRange.new(lower: 3, upper: 8), false],
        ['範囲無し', ClosedRange.empty, true],
      ]
    end

    with_them do
      context "#{params[:other]}" do
        it { is_expected.to be expected }
      end
    end
  end
  describe '閉区間aが閉区間bを完全に含むかどうかを判定する' do
    subject { empty.contain?(other) }
    where(:case_name, :other)do
      [
        ['範囲有り', ClosedRange.new(lower: 3, upper: 8)],
        ['範囲無し', ClosedRange.empty],
      ]
    end

    with_them do
      context "#{params[:other]}" do
        it { is_expected.to be false }
      end
    end
  end
  describe '閉区間aに含まれる整数を列挙できる' do
    it [] do
      expect(empty.to_a).to eq []
    end
  end
  describe '閉区間aと閉区間bの重複を取れる' do
    subject { empty * other }
    where(:case_name, :other)do
      [
        ['範囲有り', ClosedRange.new(lower: 3, upper: 8)],
        ['範囲無し', ClosedRange.empty],
      ]
    end

    with_them do
      context "#{params[:other]}" do
        it { is_expected.to eq ClosedRange.empty }
      end
    end
  end
end
