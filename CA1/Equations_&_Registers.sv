module random_pi_generator;

  parameter int NUM_PI_VALUES = 64; // The range for pi (1 to 8)
  logic [NUM_PI_VALUES:0] used; // Bit array to track used numbers
  int count; // Count of generated numbers

  // Initialize the used array and count
  initial begin
    used = 0; // Reset used flags
    count = 0; // Reset the count
  end

  // Function to generate a single unique random number in the range of 1 to NUM_PI_VALUES
  function automatic logic [7:0] generate_unique_random_number();
    int random_index;

    // Check if all unique values have been generated
    if (count >= NUM_PI_VALUES) begin
      // Reset used flags and count for new generation
      used = 0;
      count = 0;
      $display("All unique numbers have been generated. Resetting...");
    end

    // Generate a random index until an unused number is found
    do begin
      random_index = $urandom_range(1, NUM_PI_VALUES);
    end while (used[random_index]);

    // Mark this number as used
    used[random_index] = 1;
    count++; // Increment the count

    return random_index + 1; // Return the unique number (1 to NUM_PI_VALUES)
  endfunction

endmodule



module location_initializer;

  // Define output signals for i and j
  logic [7:0] i;       // i is 4 bits, as it ranges from 1 to 8
  logic [7:0] j;       // j should also be a 4-bit number (1 to 8)
  logic [7:0] p; 
  logic [3:0] x;       // pi is also 4 bits

  // Define the function that takes pi as input and returns j and i
  function void calculate_j_i(input logic [7:0] p_input); // pi is a 4-bit number (1 to 8)
    begin
      p = p_input; // Store pi in a module variable
      
      // Loop for i from 1 to 8
      for (i = 1; i <9; i++) begin
        // Calculate j such that it wraps around to stay within [1, 8]
        x = (p / 8);
        j = 8 * (x - 1) + i;
        
        // Display i and j in binary format
        $display("i = %0d, j = %0d", i, j);
      end
    end
  endfunction

endmodule


module location_initializer_tb;

  // Instance of the module under test
  location_initializer uut();
  random_pi_generator rpi(); // Instance of random number generator

  // Test procedure
  initial begin
    // Initialize waveform dump file
    $dumpfile("location_initializer_tb.vcd"); // Specify the VCD file name
    $dumpvars(0, location_initializer_tb); // Dump all signals in this module and submodules

    // Display start of test
    $display("Starting location_initializer Testbench");

    // Run multiple tests with different values of pi
    for (int test = 0; test < 5; test = test + 1) begin
      logic [7:0] test_pi; // Declare test_pi inside the loop to reset its value each time

      // Generate a random pi (1 to 8) using the non-duplicate generator
      test_pi = rpi.generate_unique_random_number(); 
      
      // Display the current test value for pi
      $display("\nTest %0d: pi = %0d", test + 1, test_pi);
      
      // Call the function within the module
      uut.calculate_j_i(test_pi);

      // Wait some time to observe results in the waveform
      #10;
    end

    // End of test
    $display("Location_initializer Testbench completed");
    $finish;
  end

endmodule
