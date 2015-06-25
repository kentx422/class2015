# coding:utf-8

require 'matrix'
require 'csv'

#カルマンフィルタを用いて未知数xを推定するアルゴリズム
class Kalman
	#観測値,観測雑音の分散，プラント雑音の共分散，推定値の初期値，推定誤差共分散の初期値を設定
	def initialize(z, r, q, x, p)
		@z = z
		@r = r
		@q = q
		@x = x
		@p = p
	end

	#推定値の計算
	#num: 現在の時間
	#return: 計算した推定値
	def estimate(num)
		k = num - 15
		#状態方程式の変数
		f = Matrix.unit(3)
		#予測値
		pre_next_x = f * @x
		#予測誤差共分散
		pre_next_p = f * @p * f.transpose + @q
		
		#観測雑音の共分散
		next_r = Matrix[[@r[((k + 1) + 1) % 2]]]
		#観測方程式の変数：a(1, a, a^2)
		next_h = Matrix[[1, (k + 1), (k + 1) ** 2]]
		#観測予測誤差共分散
		next_s =  next_h * pre_next_p * next_h.transpose + next_r
		#フィルタゲイン
		next_w = pre_next_p * next_h.transpose * next_s.inverse
		#観測予測値
		pre_next_z = next_h * pre_next_x
		#観測予測誤差
		err_pre_next_z = Matrix[[@z[num + 1]]] - pre_next_z
		#推定値　：x(x0, x1, x2)
		est_next_x = pre_next_x + next_w * err_pre_next_z
		#推定誤差共分散
		est_next_p = pre_next_p - next_w * next_s * next_w.transpose
		
		#使用する観測値を抽出
		@x = est_next_x
		@p = est_next_p
		
		#推定値を返す
		return @x
	end
end

#観測値
z = [162.1746, 139.5805, 113.8133,  94.3372,  74.7258,  59.3817,  41.4117,  26.5951,
		  20.1832,   8.8816,   1.8636,  -5.0213,  -5.8861,  -5.7711,  -4.9332,  -1.9845,
		   2.0593,  12.3849,  17.9044,  30.1826,  41.1677,  55.7128,  74.2944,  93.7607,
	   112.6638, 134.9818, 162.7143, 188.9610, 219.6236, 248.9036, 281.3082]

#観測雑音の分散
w = [1, 4]


rate = [0, 0.000001, 0.00001, 0.0001, 0.001, 0.01, 0.1, 1, 10, 100, 1000, 10000, 100000, 1000000]

CSV.open("./Kalman3-3.csv", "w") do |write|
	write << ["p", "t", "x0", "x1", "x2"]	
	rate.size.times do |a|	
		rate.size.times do |b|
			t = rate[a]
			p = rate[b]
			#プラント雑音の共分散
			q = Matrix[[(t ** 5) / 20, (t ** 4) / 8, (t ** 3) / 6], [(t ** 4) / 8, (t ** 3) / 3, (t ** 2) / 2], [(t ** 3) / 6, (t ** 2) / 2, t]]

			#推定値の初期値
			init_x = Matrix[[0], [0], [0]]

			#推定誤差共分散の初期値
			init_p = Matrix.scalar(3, p)

			main = Kalman.new(z, w, q, init_x, init_p)
			puts a
			x = init_x
			(z.size - 1).times do |i|
				x =main.estimate(i)
			end
			write << [p, t, x[0, 0], x[1, 0], x[2, 0]]
		end
	end
end
