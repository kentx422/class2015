# coding:utf-8

require 'matrix'
require 'csv'

#逐次型最小二乗法を用いて未知数xを推定するアルゴリズム
class Sequential
	#観測値,観測雑音，推定値の初期値，推定誤差共分散の初期値を設定
	def initialize(z, w, x, p)
		@z = z
		@w = w
		@x = x
		@p = p
	end

	#推定値の計算
	#num: 現在の時間
	#return: 計算した推定値
	def estimatex(num)
		k = num - 15
		#観測雑音の共分散
		next_r = Matrix[[@w[((k + 1) + 1) % 2]]]
		#puts (k + 1), next_r
		#変数行列：a(1, a, a^2)
		next_a = Matrix[[1, (k + 1), (k + 1) ** 2]]
		#観測予測誤差共分散
		next_s =  next_a * @p * next_a.transpose + next_r
		#フィルタゲイン
		next_w = @p * next_a.transpose * next_s.inverse
		#推定値　：x(x0, x1, x2)
		next_x = @x + next_w * (Matrix[[@z[num + 1]]] - next_a * @x)

		#推定誤差共分散
		next_p = @p - next_w * next_s * next_w.transpose
		
		#使用する観測値を抽出
		@x = next_x
		@p = next_p
		
		#推定値を返す
		return next_x
	end
end

#観測値
z = [162.1746, 139.5805, 113.8133,  94.3372,  74.7258,  59.3817,  41.4117,  26.5951,
		  20.1832,   8.8816,   1.8636,  -5.0213,  -5.8861,  -5.7711,  -4.9332,  -1.9845,
		   2.0593,  12.3849,  17.9044,  30.1826,  41.1677,  55.7128,  74.2944,  93.7607,
	   112.6638, 134.9818, 162.7143, 188.9610, 219.6236, 248.9036, 281.3082]

#観測雑音
w = [1.0, 4.0]

#推定値の初期値
init_x = Matrix[[-509.9123999735], [-68.6040499975], [-1.5865499999]]

#推定誤差共分散の初期値
init_p = Matrix[[171405.99999279404, 24590.999998966337, 877.9999999630993], [24590.99999896593, 3528.499999851668, 125.9999999947047], [877.9999999630708, 125.99999999470268, 4.499999999810891]]
main = Sequential.new(z, w, init_x, init_p)

CSV.open("SequentialDataTest.csv", "w") do |write|
	write << ["a", "x0", "x1", "x2"]
	write << ["-15", 0, 0, 0]
	2.upto(z.size - 2) do |i|
		x = main.estimatex(i)
		write << [(i + 1) - 15, x[0, 0], x[1, 0], x[2, 0]]
	end
end
