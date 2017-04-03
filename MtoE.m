function E = MtoE(M,e)

error = 1;
Guess = M;
while error > 0.00001
    error = M - Guess + e*sin(Guess);
    slope = -1 + e*cos(Guess);
    Guess = Guess - error/slope;
    error = abs(error);
end

    E = Guess;

end