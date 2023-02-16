t = d[0][0]
d[0].map! { |n| n /= t}

t = d[1][0]
d[1].map!.with_index { |n,i| n -= t * d[0][i]}

t = d[2][0]
d[2].map!.with_index { |n,i| n -= t * d[0][i]}



t = d[1][1]
d[1].map! { |n| n /= t}

t = d[0][1]
d[0] = d[0].map.with_index { |n,i| n -= t * d[1][i]}

t = d[2][1]
d[2] = d[2].map.with_index { |n,i| n -= t * d[1][i]}



t = d[2][2]
d[2].map! { |n| n /= t}

t = d[0][2]
d[0] = d[0].map.with_index { |n,i| n -= t * d[2][i]}

t = d[1][2]
d[1] = d[1].map.with_index { |n,i| n -= t * d[2][i]}

