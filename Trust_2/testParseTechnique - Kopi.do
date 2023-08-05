mata:

technique = "bfgs 30 nr 5"

tech = tokens(technique)
colshape(tech,2)

index = 1..cols(tech)
evenIndex = select(index,mod(index,2):==0)
oddIndex  = select(index,mod(index,2):!=0)
tech[evenIndex]
tech[oddIndex]


end
