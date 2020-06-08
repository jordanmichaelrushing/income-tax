module IncomeTax
  module Countries
    class UnitedStates
      class Federal < Models::Progressive
        wants_options :married, :joint_statement, :head_of_household

        def level_category
          return :single unless married?
          return :joint if joint_statement?
          return :separate unless head_of_household or head_of_household.nil?
          :head_of_household
        end

        GROUPS = [:single, :joint, :separate, :head_of_household]

        MARGINAL_TAX = [
          [ "10%", 9875,   19750,  9875,   14100  ],
          [ "12%", 40125,  80250,  40125,  53700  ],
          [ "22%", 85525,  171050, 85525,  85500 ],
          [ "24%", 163300, 326600, 163300, 163300 ],
          [ "32%", 207350, 414700, 207350, 207350 ],
          [ "35%", 518400, 622050, 311025, 518400 ],
        ]

        REMAINDER          = "37%"
        STANDARD_DEDUTIONS = [ 12400, 24800, 12400, 18650 ]

        GROUPS.each_with_index do |group, index|
          levels group do
            MARGINAL_TAX.each do |rate, *boundries|
              boundry = boundries[index] + STANDARD_DEDUTIONS[index]
              level boundry, rate
            end
            remainder REMAINDER
          end
        end
      end
    end
  end
end
