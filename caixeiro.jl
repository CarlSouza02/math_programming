#1 Pacotes
using JuMP
using Gurobi

#2 Conjuntos
C = [1, 2, 3, 4] # cidades
n = length(C)

#3 Dados
c = [
    0   9  20  30
   14   0   8  15
   15  18   0   7
    6  12  20   0
]

#4 Modelo
model = Model(Gurobi.Optimizer)
set_silent(model)

#5 Variáveis
@variable(model, x[i in C, j in C; i != j], Bin)
@variable(model, 1 <= u[C] <= n)

#6 Função Objetivo
@objective(model, Min, sum(c[i,j] * x[i,j] for i in C, j in C if i != j))

#7 Restrições

# Sai exatamente uma vez de cada cidade
@constraint(model, [i in C], sum(x[i,j] for j in C if j != i) == 1)

# Entra exatamente uma vez em cada cidade
@constraint(model, [j in C], sum(x[i,j] for i in C if i != j) == 1)

# Fixar cidade inicial
@constraint(model, u[1] == 1)

# Eliminar subtours - MTZ
@constraint(model, [i in C, j in C; i != j && i != 1 && j != 1],
    u[i] - u[j] + n * x[i,j] <= n - 1
)

#8 Solver
optimize!(model)

#9 Imprimir
println("Status : ", termination_status(model))

if has_values(model)
    println("Z* = ", objective_value(model))

    println("Arcos escolhidos:")
    for i in C
        for j in C
            if i != j && value(x[i,j]) > 0.5
                println("Vai da cidade $i para a cidade $j")
            end
        end
    end
end

println("Chegamos ao fim!")