#1 Pacotes
using JuMP
using Gurobi

#2 Conjuntos
A = [1, 2, 3] # agentes
J = [1, 2, 3] # tarefas

#3 Dados
c = [
    8  6  10
    9  7   4
    5  8   6
]

#4 Modelo
model = Model(Gurobi.Optimizer)
set_silent(model)

#5 Variáveis
@variable(model, x[A, J], Bin)

#6 Função Objetivo
@objective(model, Min, sum(c[i,j] * x[i,j] for i in A, j in J))

#7 Restrições

# Cada agente faz exatamente uma tarefa
@constraint(model, [i in A], sum(x[i,j] for j in J) == 1)

# Cada tarefa é feita por exatamente um agente
@constraint(model, [j in J], sum(x[i,j] for i in A) == 1)

#8 Solver
optimize!(model)

#9 Imprimir
println("Status : ", termination_status(model))

if has_values(model)
    println("Z* = ", objective_value(model))

    println("Alocação das tarefas:")
    for i in A
        for j in J
            if value(x[i,j]) > 0.5
                println("A tarefa $j deve ser feita pelo agente $i")
            end
        end
    end
end

println("Chegamos ao fim!")