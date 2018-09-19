class Loan
    attr_reader :id, :country, :amount

    def initialize(id, country, amount)
        @id = id.strip
        @country = country.strip
        @amount = amount.strip.to_f
    end
end
