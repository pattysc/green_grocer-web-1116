def consolidate_cart(cart)
  consolidated = {}
  cart.each do |hash|
    hash.each do |key, infohash|
      if consolidated.keys.include?(key)
        consolidated[key][:count] += 1
      else
        consolidated[key] = infohash
        consolidated[key][:count] = 1
      end
    end
  end
  return consolidated
end


def apply_coupons(cart, coupons)
  if coupons.empty?
    return cart
  else
    cartwcoupons = {}
    i = 0

    cart.each do |item, info|
      coupons.each do |coupon|
        if coupon[:item] == item
          cartwcoupons[item] = info
          if info[:count] >= coupon[:num]
            cartwcoupons[item][:count] = info[:count] - coupon[:num]
            cartwcoupons["#{item} W/COUPON"] ||= {:price => 0, :clearance => true, :count => 0}
            cartwcoupons["#{item} W/COUPON"][:price] = coupon[:cost]
            cartwcoupons["#{item} W/COUPON"][:clearance] = info[:clearance]
            cartwcoupons["#{item} W/COUPON"][:count] += 1
          end
        else
          cartwcoupons[item] = info
        end
      end
    end
  end
  return cartwcoupons
end


def apply_clearance(cart)
  cart.each do |item, infohash|
      if infohash[:clearance]
        infohash[:price] = (infohash[:price]*0.8).round(2)
      end
  end
  return cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_clearance(apply_coupons(cart, coupons))

  total = 0
  cart.each do |item, infohash|
    total += (infohash[:price] * infohash[:count])
  end

  if total > 100
    return total*0.9
  else
    return total
  end
end
