#1 Pacotes
using JuMP
using Gurobi

#2 Conjuntos
I = [1, 2, 3, 4, 5] # itens

#3 Dados
v = [12, 20, 15, 18, 10] # valores
p = [2, 5, 3, 4, 1]      # pesos
B = 8                    # capacidade

#4 Modelo
model = Model(Gurobi.Optimizer)
set_silent(model)

#5 Variáveis
@variable(model, x[I], Bin)

#6 Função Objetivo
@objective(model, Max, sum(v[i] * x[i] for i in I))

#7 Restrição
@constraint(model, sum(p[i] * x[i] for i in I) <= B)

#8 Solver
optimize!(model)

#9 Imprimir
println("Status : ", termination_status(model))

if has_values(model)
    println("Z* = ", objective_value(model))

    println("Itens escolhidos:")
    for i in I
        if value(x[i]) > 0.5
            println("Item $i escolhido")
        end
    end

    println("Peso usado = ", sum(p[i] * value(x[i]) for i in I))
    println("Capacidade = ", B)
end

println("Chegamos ao fim!")