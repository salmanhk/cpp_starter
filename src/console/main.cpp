// File: src_dir/console/main.cpp

#include <pch.h>
#include "adder.h"

#include "duckdb.hpp"
#include <websocketpp/config/asio_no_tls.hpp>
#include <websocketpp/server.hpp>
#include <fmt/core.h>
#include <spdlog/spdlog.h>
#include <zmq.hpp>

#ifdef __CUDACC__
    #include "cuda_functions.h"
#endif

std::atomic<bool> keepRunning(true);

#ifdef __CUDACC__
    extern void addWithCuda(int* c, const int* a, const int* b, int size);

    //////////////
    void example_cudatest() {
    std::cout << "Testing Cuda\n.";
    const int arraySize = 5;
    int a[arraySize] = { 1, 2, 3, 4, 5 };
    int b[arraySize] = { 10, 20, 30, 40, 50 };
    int c[arraySize] = { 0 };

    // Add vectors in parallel.
    addWithCuda(c, a, b, arraySize);

    std::cout << "Result:";
    for (int i = 0; i < arraySize; ++i) {
        std::cout << " " << c[i];
    }
    std::cout << std::endl;
    std::cout << "Testing Cuda ok\n.";
    }
#endif

//////////////
void example_duckdb() {

    duckdb::DuckDB db(nullptr);
    duckdb::Connection con(db);

    con.Query("CREATE TABLE items (id INTEGER, name VARCHAR)");
    con.Query("INSERT INTO items VALUES (1, 'Laptop'), (2, 'Smartphone'), (3, 'Tablet')");

    auto result = con.Query("SELECT * FROM items");

    if (!result->HasError() && result->RowCount() > 0) {
        for (size_t i = 0; i < result->RowCount(); i++) {

            auto id = result->GetValue(0, i).GetValue<int64_t>();
            auto name = result->GetValue(1, i).GetValue<std::string>();

            std::cout << "ID: " << id << ", Name: " << name << std::endl;
        }
    } else {
        std::cerr << "Query failed or returned no rows: " << result->GetError() << std::endl;
    }

}


////////////////
double objective(const std::vector<double> &x, std::vector<double> &grad, void *data) {
    if (!grad.empty()) {
        grad[0] = 0.0;
    }
    return x[0] * x[0] + x[1] * x[1]; 
}

void nlopt_example() {
    try {
        nlopt::opt opt(nlopt::LD_LBFGS, 2);

        std::vector<double> lb(2, -1.0); // Lower bounds
        opt.set_lower_bounds(lb);

        opt.set_min_objective(objective, nullptr);

        opt.set_xtol_rel(1e-4);

        std::vector<double> x(2, 1.0); 
        double minf; 

        nlopt::result result = opt.optimize(x, minf);

        std::cout << "Found minimum at f(" << x[0] << "," << x[1] << ") = " << minf << std::endl;
    }
    catch (std::exception &e) {
        std::cerr << "NLopt failed: " << e.what() << std::endl;
    }    
}
////////////////
void server_thread() {
    zmq::context_t context(1);
    zmq::socket_t socket(context, ZMQ_REP);
    socket.bind("tcp://*:5555");

    while (keepRunning) {
        zmq::message_t request;

        zmq::pollitem_t items[] = {{static_cast<void*>(socket), 0, ZMQ_POLLIN, 0}};
        zmq::poll(items, 1, std::chrono::milliseconds(100));


        if (items[0].revents & ZMQ_POLLIN) {
            zmq::message_t reply;
            auto result = socket.recv(reply, zmq::recv_flags::none);
            if(result.has_value()) {
                std::cout << reply.to_string() << '\n';
            }            

            std::this_thread::sleep_for(std::chrono::seconds(1));

            zmq::message_t request(5);
            memcpy(request.data(), "World", 5);
            socket.send(request, zmq::send_flags::none);
        }
    }
}

void client_thread() {
    zmq::context_t context(1);
    zmq::socket_t socket(context, ZMQ_REQ);
    socket.connect("tcp://localhost:5555");

    for (int request_nbr = 0; request_nbr != 3; request_nbr++) {
        zmq::message_t request(5);
        memcpy(request.data(), "Hello", 5);
        socket.send(request, zmq::send_flags::none);

        zmq::message_t reply;
        auto result = socket.recv(reply, zmq::recv_flags::none);
        if(result.has_value()) {
            std::cout << reply.to_string() << '\n';
        }
    }
}

//////////////////
void
eigen_example()
{
    Eigen::Matrix3f matA;
    matA << 1, 2, 3, 4, 5, 6, 7, 8, 9;

    Eigen::Matrix3f matB;
    matB << 9, 8, 7, 6, 5, 4, 3, 2, 1;

    Eigen::Matrix3f matSum = matA + matB;

    Eigen::Matrix3f matProduct = matA * matB;

    std::cout << "Matrix A:\n" << matA << "\n\n";
    std::cout << "Matrix B:\n" << matB << "\n\n";
    std::cout << "Matrix A + B:\n" << matSum << "\n\n";
    std::cout << "Matrix A * B:\n" << matProduct << "\n";
}

void spdlog_example()
{
    spdlog::info("Welcome to spdlog!");
    spdlog::error("An error message example");

    int temperature = 25;
    spdlog::warn("Current temperature is {} degrees Celsius.", temperature);

    spdlog::debug("This is a debug message.");    
}

int main() {

#ifdef __CUDACC__
    example_cudatest();
#endif

    std::thread server(server_thread);
    std::thread client(client_thread);

    client.join();
    keepRunning = false;
    server.join();


    int result = lib_a::adder(5, 4);
    std::cout << "The result of 5 + 4 is " << result << std::endl;

    //
    eigen_example();

    //
    nlopt_example();

    //
    spdlog_example();

    //
    std::string message = fmt::format("Hello, {}!", "World");
    fmt::print("Formatted Message: {}\n", message);
    fmt::print("Hello, {}!\n", "fmt");

    //
    example_duckdb();

    std::cin.get();

    return 0;
}
