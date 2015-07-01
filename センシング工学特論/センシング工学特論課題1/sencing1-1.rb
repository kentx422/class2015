# -*- encoding:utf-8 -*-
require 'matrix'

#初期値の設定:データ数31
$z = [162.1746, 139.5805, 113.8133, 94.3372, 74.7258,   59.3817,  41.4117,  26.5951, 20.1832,   8.8816,   1.8636,   -5.0213, -5.8861,   -5.7711,  -4.9332,  -1.9845, 2.0593,    12.3849,  17.9044,  30.1826, 41.1677,   55.7128,  74.2944,  93.7607, 112.6638,  134.9818, 162.7143, 188.9610, 219.6236,  248.9036, 281.3082]
$size = $z.size

#H & R の作成(配列)
h = Array.new($size){|i| Array.new(3, 0)}
r = Array.new($size){|i| Array.new($size, 0)}
sigma = [4.0, 1.0]
$size.times do |i|
	k = i-15
	h[i][0] = 1
	h[i][1] = k
	h[i][2] = k**2
	r[i][i] = sigma[k%2]
end

#行列変換
h = Matrix.rows(h, false)
r = Matrix.rows(r, false)
#推定値の算出
z = Matrix.rows([$z], false).transpose
x = (h.transpose * r.inverse * h).inverse * h.transpose * r.inverse * z
puts x
