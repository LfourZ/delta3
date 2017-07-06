
function sieve_of_eratosthenes(n)
  local is_prime = {}

  for i = 1, n do
    is_prime[i] = 1 ~= i
  end

  for i = 2, math.floor(math.sqrt(n)) do
    if is_prime[i] then
      for j = i*i, n, i do
        is_prime[j] = false
      end
    end
  end

  return is_prime
end

local primes = sieve_of_eratosthenes(444)

for key, value in pairs(primes) do
  if (value) then
    print(key)
  end
end
