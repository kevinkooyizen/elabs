module RankingExtension
    module CosineDistance
        extend ActiveSupport::Concern

        def norm(v)
            result = v.reduce(0) {|sum, ele|
                sum+=ele ** 2}
            result ** 0.5
        end

        def dot_product(v1, v2)
            result = 0
            (0...v1.length).each do |i|
                result+= v1[i] * v2[i]
            end
            result
        end

        def cosine_distance(v1, v2)
            distance = dot_product(v1, v2)/(norm(v1) * norm(v2) + 1)
        end

    end
end