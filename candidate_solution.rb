class CandidateSolution
    attr_reader :loans, :error, :in_error, :cn_error, :ru_error, :amount_error

    def initialize(loans)
        @loans = loans
        @error = compute_average_error(loans)
    end

    def compute_average_error(loans)
        # India target 0.5
        @in_error = (0.5 - loans.select { |x| x.country == 'IN' }.count / loans.count.to_f).abs

        # China 0.2
        @cn_error = (0.2 - loans.select { |x| x.country == 'CN' }.count / loans.count.to_f).abs

        # Russia 0.1
        @ru_error = (0.1 - loans.select { |x| x.country == 'RU' }.count / loans.count.to_f).abs

        # Bond Size #TODO:
        @amount_error = (2000000.0 - loans.sum { |x| x.amount}).abs / 2000000.0

        tot_error = (in_error + cn_error + ru_error + amount_error)
        # byebug if tot_error == 0.0

        return tot_error
    end

    def self.fittest(population, best_from_gen_num)
        res = []
        population = population.sort_by { |chromo| chromo.error }
        best_from_gen_num.times do |x|
            res << population[x]
        end
        return res
    end

    def self.select_fittest(pop, total, n)
        random_arr = (0..total).to_a.shuffle.take(n)

        cur_error = 99999999
        cur_fitest = nil

        random_arr.each do |x|
            if pop[x].error < cur_error
                cur_fitest = pop[x]
                cur_error = pop[x].error
            end
        end

        return cur_fitest
    end

    def self.crossover(parent1, parent2)
        new_loans_size = 0
        child_loans = []
        if Random.new.rand > 0.5
            new_loans_size = parent1.loans.count
        else
            new_loans_size = parent2.loans.count
        end

        new_loans_size.times do |x|
            if Random.new.rand > 0.5
                child_loans << (parent1.loans[x].nil? ? parent2.loans[x] : parent1.loans[x])
            else
                child_loans << (parent2.loans[x].nil? ? parent1.loans[x] : parent2.loans[x])
            end
        end

        return CandidateSolution.new(child_loans)
    end

    def self.mutate(parent1, total_loans)
        child_loans = parent1.loans

        # Add or remove 10% of loans
        if Random.new.rand < 0.4
            delta = (parent1.loans.count * 0.1).round
            delta = 1 if delta == 0

            if Random.new.rand < 0.5 # adding delta random loans
                parent_loan_ids = parent1.loans.map { |y| y.id}
                new_loans = total_loans.reject { |x| parent_loan_ids.include?(x.id) }.shuffle.take(delta)
                new_loans = [] if (new_loans.nil? || new_loans.first.nil?)
                child_loans = parent1.loans + new_loans
            else # remove delta random loans from parent
                if parent1.loans.count > delta
                    child_loans = parent1.loans - parent1.loans.shuffle.take(delta)
                end
            end
        end

        # Swap loans
        child_loans.count.times do |x|
            if Random.new.rand < 0.2
                # puts ""
                # puts "Child Loans count: #{child_loans.count} loans: #{child_loans.to_s}"
                
                child_loan_ids = child_loans.reject{ |a| a.nil? }.map { |y| y.id }
                avail_swap_loans = total_loans.reject { |x| child_loan_ids.include?(x.id) }

                child_loans[x] = avail_swap_loans.shuffle.first
            end
        end

        return CandidateSolution.new(child_loans)
    end
end