require './bond_data'
require 'byebug'

number_of_generations = 100 #0
population_size = 1000
fittest = 9999
best_from_gen = 10

bond_data = BondData.new(population_size)
population = bond_data.initial_pop

fit_cand = nil

number_of_generations.times do |gen|
    puts "Generation: #{gen + 1} Fitness error: #{fittest}"
    new_pop = []

    # Pick some best solutions not to mutate or breed
    best_solutions = CandidateSolution.fittest(population, best_from_gen)
    best_solutions.each { |sol| new_pop << sol }

    # byebug

    ((population_size - best_from_gen) / 2).times do |x|
        parent1 = CandidateSolution.select_fittest(population, population_size - 1, best_from_gen)
        parent2 = CandidateSolution.select_fittest(population, population_size - 1, best_from_gen)

        if Random.new.rand > 0.5
            child1 = CandidateSolution.crossover(parent1, parent2);
            child2 = CandidateSolution.crossover(parent1, parent2);
            new_pop << child1; new_pop << child2;
        else
            mutated_child1 = CandidateSolution.mutate(parent1, bond_data.loans)
            mutated_child2 = CandidateSolution.mutate(parent2, bond_data.loans)
            new_pop << mutated_child1; new_pop << mutated_child2;
        end
    end

    population = new_pop
    fit_cand = CandidateSolution.fittest(population, 1).first
    fittest = fit_cand.error

    # byebug if fit_cand.error == 0.0

    # r = 1

    break if fit_cand.error == 0.0
end

puts ''
puts "Target solution => ID: 50%, CN: 20%, RU: 10%, Total: 2,000,000"
puts "Best candidate solution with error of: #{fit_cand.error} with #{fit_cand.loans.count} loans:"
fit_cand.loans.sort_by { |y| y.country }.each do |x|
    puts "LoanId: #{x.id} Country: #{x.country} Amount: #{x.amount}"
end

puts "IN %: #{fit_cand.loans.select { |x| x.country == 'IN' }.count / fit_cand.loans.count.to_f * 100.0}"
puts "CN %: #{fit_cand.loans.select { |x| x.country == 'CN' }.count / fit_cand.loans.count.to_f * 100.0}"
puts "RU %: #{fit_cand.loans.select { |x| x.country == 'RU' }.count / fit_cand.loans.count.to_f * 100.0}"
puts "Total: #{fit_cand.loans.sum { |x| x.amount}}"

# byebug

r = 1

# puts data