require 'byebug'
require './candidate_solution'
require './loan'

class BondData
    attr_reader :loans, :initial_pop

    def initialize(initial_pop_size)
        data_rows = data_string.split("\n")
        data_rows = data_rows.map { |x| x.split(",") }

        @loans = build_loans(data_rows)
        @initial_pop = gen_initial_candidate_solution_population(initial_pop_size)
    end

    private

    def build_loans(data_rows)
        loan_list = []
        data_rows.each do |row|
            loan_list << Loan.new(row[0],row[1],row[2])
        end
        loan_list
    end

    def gen_initial_candidate_solution_population(initial_pop_size)
        initial_candidate_solution_pop = []
        initial_pop_size.times do |x|
            rand_amount = (1..99).to_a.shuffle.first
            cs = CandidateSolution.new(@loans.shuffle.take(rand_amount))
            initial_candidate_solution_pop << cs
        end
        initial_candidate_solution_pop
    end

    def data_string
        "1,RU,20000
        2,IN,25000
        3,CN,30000
        4,RU,35000
        5,IN,40000
        6,CN,45000
        7,RU,50000
        8,IN,55000
        9,CN,60000
        10,RU,65000
        11,IN,70000
        12,CN,75000
        13,RU,80000
        14,IN,85000
        15,CN,90000
        16,RU,95000
        17,IN,100000
        18,CN,105000
        19,RU,110000
        20,IN,115000
        21,CN,120000
        22,RU,125000
        23,IN,130000
        24,CN,135000
        25,RU,140000
        26,IN,145000
        27,CN,150000
        28,RU,155000
        29,IN,160000
        30,CN,165000
        31,RU,170000
        32,IN,175000
        33,CN,180000
        34,RU,185000
        35,IN,190000
        36,CN,195000
        37,RU,200000
        38,IN,205000
        39,CN,210000
        40,RU,215000
        41,IN,220000
        42,CN,225000
        43,RU,230000
        44,IN,235000
        45,CN,240000
        46,RU,20000
        47,IN,25000
        48,CN,30000
        49,RU,35000
        50,IN,40000
        51,CN,45000
        52,RU,50000
        53,IN,55000
        54,CN,60000
        55,RU,65000
        56,IN,70000
        57,CN,75000
        58,RU,80000
        59,IN,85000
        60,CN,90000
        61,SA,20000
        62,SA,25000
        63,SA,30000
        64,SA,35000
        65,SA,40000
        66,SA,45000
        67,SA,50000
        68,SA,55000
        69,SA,60000
        70,SA,65000
        71,SA,70000
        72,SA,75000
        73,SA,80000
        74,SA,85000
        75,SA,90000
        76,SA,95000
        77,SA,100000
        78,SA,105000
        79,SA,110000
        80,SA,115000
        81,SA,120000
        82,SA,125000
        83,SA,130000
        84,SA,135000
        85,SA,140000
        86,SA,145000
        87,SA,150000
        88,SA,155000
        89,SA,160000
        90,SA,165000
        91,SA,170000
        92,SA,175000
        93,SA,180000
        94,SA,185000
        95,SA,190000
        96,SA,195000
        97,SA,200000
        98,SA,205000
        99,SA,210000
        100,SA,215000"
    end
end