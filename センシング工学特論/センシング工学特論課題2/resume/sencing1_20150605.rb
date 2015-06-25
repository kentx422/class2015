# coding:utf-8

require 'matrix'
require 'csv'

#バッチ型最小二乗法を用いて未知数xを推定するアルゴリズム
class Batch
	#観測値と観測雑音を設定
	def initialize(z, w)
		@z = z
		@w = w	
	end

	#推定値の計算
	#num: 現在の時間
	#return: 計算した推定値
	def estimate(num)
		#観測雑音の共分散行列
		r = Array.new(num){Array.new(num, 0)}
		#変数行列：a(1, a, a^2)
		a = Array.new(num){Array.new(3, 0)}
		#推定値　：x(x0, x1, x2)
		x = Array.new(3, 0)
		
		#変数行列と観測雑音の共分散行列を設定
		num.times do |i|
			k = i - 15
			a[i][0] = 1
			a[i][1] = k
			a[i][2] = k ** 2
			r[i][i] = @w[(k + 1) % 2]	
		end
		
		#配列を行列に変換
		a = Matrix.rows(a)
		r = Matrix.rows(r)
		#使用する観測値を抽出
		z = Matrix.rows([@z.slice(0, num)])
		#推定値を計算
		x = (a.transpose * r.inverse * a).inverse * a.transpose * r.inverse * z.transpose

		#推定値を返す
		return x
	end
end

#観測値
z = [ 162.1746, 139.5805, 113.8133,  94.3372,  74.7258,  59.3817,  41.4117,  26.5951,
       20.1832,   8.8816,   1.8636,  -5.0213,  -5.8861,  -5.7711,  -4.9332,  -1.9845,
        2.0593,  12.3849,  17.9044,  30.1826,  41.1677,  55.7128,  74.2944,  93.7607,
      112.6638, 134.9818, 162.7143, 188.9610, 219.6236, 248.9036, 281.3082]

#観測雑音
w = [1, 4]

#バッチ型最小二乗法を用いて未知数xを推定
main = Batch.new(z, w)

#CSVファイルへの書き出し
CSV.open("/home/kent/ruby/BatchData.csv", "w") do |write|
	write << ["a", "x0", "x1", "x2"]
	4.upto(z.size) do |i|
		x = main.estimate(i)
		write << [(i - 1) - 15, x[0, 0], x[1, 0], x[2, 0]]
	end
end
