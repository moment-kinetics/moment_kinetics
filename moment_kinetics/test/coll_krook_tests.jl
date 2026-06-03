module coll_krook_tests

# Test generated from TOML input files

include("setup.jl")

using Base.Filesystem: tempname
using MPI

using moment_kinetics.interpolation: interpolate_to_grid_z
using moment_kinetics.load_data: get_run_info_no_setup, close_run_info,
                                 postproc_load_variable
using moment_kinetics.utils: merge_dict_with_kwargs!

# default inputs for tests
dkions_n10 = OptionsDict(
 "output" => OptionsDict(
     "display_timing_info" => false
    ),
 "r" => OptionsDict(
     "ngrid" => 1,
     "nelement" => 1
    ),
 "evolve_moments" => OptionsDict(
     "pressure" => true,
     "density" => true,
     "moments_conservation" => true,
     "parallel_flow" => true
    ),
 "ion_species_1" => OptionsDict(
     "initial_temperature" => 0.3333333333333333,
     "initial_density" => 40.0
    ),
 "krook_collisions" => OptionsDict(
     "use_krook" => true,
     "frequency_option" => "reference_parameters"
    ),
 "vpa" => OptionsDict(
     "ngrid" => 6,
     "discretization" => "chebyshev_pseudospectral",
     "nelement" => 31,
     "L" => 14.0,
     "element_spacing_option" => "coarse_tails8.660254037844386",
     "bc" => "zero"
    ),
 "z" => OptionsDict(
     "ngrid" => 5,
     "discretization" => "gausslegendre_pseudospectral",
     "nelement" => 20,
     "L" => 1.4,
     "bc" => "wall"
    ),
 "vpa_IC_ion_species_1" => OptionsDict(
     "initialization_option" => "gaussian",
     "density_amplitude" => 1.0,
     "temperature_amplitude" => 0.0,
     "density_phase" => 0.0,
     "upar_amplitude" => 0.0,
     "temperature_phase" => 0.0,
     "upar_phase" => 0.0
    ),
 "composition" => OptionsDict(
     "T_e" => 0.8,
     "electron_physics" => "boltzmann_electron_response",
     "n_ion_species" => 1,
     "n_neutral_species" => 0
    ),
 "ion_source_2" => OptionsDict(
     "source_type" => "density_midpoint_control",
     "source_T" => 0.1,
     "active" => true,
     "PI_density_controller_I" => 5.0,
     "source_strength" => 40.0,
     "z_profile" => "wall_exp_decay",
     "PI_density_controller_P" => 7.0,
     "PI_density_target_amplitude" => 10.0,
     "z_width" => 0.2
    ),
 "z_IC_ion_species_1" => OptionsDict(
     "initialization_option" => "gaussian",
     "density_amplitude" => 0.001,
     "temperature_amplitude" => 0.0,
     "density_phase" => 0.0,
     "upar_amplitude" => 1.4142135623730951,
     "temperature_phase" => 0.0,
     "upar_phase" => 0.0
    ),
 "ion_source_1" => OptionsDict(
     "PI_temperature_controller_I" => 500.0,
     "source_type" => "temperature_midpoint_control",
     "source_T" => 1.5,
     "active" => true,
     "PI_temperature_target_amplitude" => 0.3333333333333333,
     "source_strength" => 14.0,
     "z_profile" => "super_gaussian_4",
     "PI_temperature_controller_P" => 500.0,
     "z_width" => 0.38
    ),
 "timestepping" => OptionsDict(
     "nstep" => 4000,
     "steady_state_residual" => true,
     "dt" => 0.0005,
     "nwrite" => 2000,
     "type" => "SSPRK4",
     "nwrite_dfns" => 2000,
     "print_nT_live" => true
    )
)

coll_krook_n10 = recursive_merge(dkions_n10,
                               OptionsDict(
 "vpa" => OptionsDict(
     "ngrid" => 1,
     "nelement" => 1,
    ),
 "composition" => OptionsDict(
     "ion_physics" => "coll_krook_ions"
    ),
 "z" => OptionsDict(
     "ngrid" => 6,
     "nelement" => 40,
    ),
 "timestepping" => OptionsDict(
     "nstep" => 25000,
     "dt" => 2.0e-5,
     "nwrite" => 2500,
     "nwrite_dfns" => 2500,
    )
))

dkions_n1 = recursive_merge(dkions_n10,
                               OptionsDict(
 "ion_source_2" => OptionsDict(
     "source_strength" => 4.0,
     "PI_density_target_amplitude" => 1.0
    ),
 "vpa" => OptionsDict(
     "nelement" => 41
    ),
 "ion_source_1" => OptionsDict(
     "source_strength" => 1.4
    ),
 "timestepping" => OptionsDict(
     "nstep" => 400,
     "nwrite" => 200,
     "nwrite_dfns" => 200
    ),
 "z" => OptionsDict(
     "nelement" => 32
    ),
 "ion_species_1" => OptionsDict(
     "initial_density" => 4.0
    )
))

coll_krook_n1 = recursive_merge(dkions_n1,
                               OptionsDict(
 "vpa" => OptionsDict(
     "ngrid" => 1,
     "nelement" => 1,
    ),
 "z" => OptionsDict(
     "ngrid" => 6,
     "nelement" => 40,
    ),
 "composition" => OptionsDict(
     "ion_physics" => "coll_krook_ions"
    ),
 "timestepping" => OptionsDict(
     "nstep" => 250000,
     "dt" => 2.0e-6,
     "nwrite" => 25000,
     "nwrite_dfns" => 25000,
    )
))

dkions_n100 = recursive_merge(dkions_n10,
                               OptionsDict(
 "ion_source_2" => OptionsDict(
     "PI_density_controller_I" => 500.0,
     "source_strength" => 200.0,
     "PI_density_controller_P" => 700.0,
     "PI_density_target_amplitude" => 100.0
    ),
 "vpa" => OptionsDict(
     "nelement" => 41
    ),
 "ion_source_1" => OptionsDict(
     "source_strength" => 140.0
    ),
 "timestepping" => OptionsDict(
     "nstep" => 80,
     "dt" => 0.0002,
     "nwrite" => 40,
     "nwrite_dfns" => 40
    ),
 "z" => OptionsDict(
     "nelement" => 32
    ),
 "ion_species_1" => OptionsDict(
     "initial_density" => 130.0
    )
))

coll_krook_n100 = recursive_merge(dkions_n100,
                               OptionsDict(
 "vpa" => OptionsDict(
     "ngrid" => 1,
     "nelement" => 1,
    ),
 "z" => OptionsDict(
     "ngrid" => 6,
     "nelement" => 40,
    ),
 "composition" => OptionsDict(
     "ion_physics" => "coll_krook_ions"
    ),
 "timestepping" => OptionsDict(
     "nstep" => 25000,
     "dt" => 2.0e-5,
     "nwrite" => 2500,
     "nwrite_dfns" => 2500,
    )
))


# Here choose the names for each test
dkions_n10 = recursive_merge(dkions_n10,
                               OptionsDict("output" => OptionsDict("run_name" => "dkions_n10.0_for_test_generation")))
coll_krook_n10 = recursive_merge(coll_krook_n10,
                               OptionsDict("output" => OptionsDict("run_name" => "coll_krook_n10.0")))
dkions_n1 = recursive_merge(dkions_n1,
                               OptionsDict("output" => OptionsDict("run_name" => "dkions_n1.0_for_test_generation")))
coll_krook_n1 = recursive_merge(coll_krook_n1,
                               OptionsDict("output" => OptionsDict("run_name" => "coll_krook_n1.0")))
dkions_n100 = recursive_merge(dkions_n100,
                               OptionsDict("output" => OptionsDict("run_name" => "dkions_n100.0_for_test_generation")))
coll_krook_n100 = recursive_merge(coll_krook_n100,
                               OptionsDict("output" => OptionsDict("run_name" => "coll_krook_n100.0")))

"""
Run a test for a single set of parameters
"""
function run_test_with_restart(dkions_test_input, coll_krook_test_input, expected_phi; rtol=1.e-12, atol=1.e-12, args...)
    # by passing keyword arguments to run_test, args becomes a Tuple of Pairs which can be
    # used to update the default inputs

    # Make a copy to make sure nothing modifies the input Dicts defined in this test
    # script.
    dkions_input = deepcopy(dkions_test_input)
    coll_krook_input = deepcopy(coll_krook_test_input)

     # Convert keyword arguments to a unique name
    dkions_name = dkions_input["output"]["run_name"]
    if length(args) > 0
        dkions_name = string(dkions_name, "_", (string(k, "-", v, "_") for (k, v) in args)...)  
        # Remove trailing "_"
        dkions_name = chop(dkions_name)
    end

    # Convert keyword arguments to a unique name
    coll_krook_name = coll_krook_input["output"]["run_name"]
    if length(args) > 0
        coll_krook_name = string(coll_krook_name, "_", (string(k, "-", v, "_") for (k, v) in args)...)

        # Remove trailing "_"
        coll_krook_name = chop(coll_krook_name)
    end

    # Provide some progress info
    println("    - testing ", coll_krook_name)

    # Update default inputs with values to be changed
    merge_dict_with_kwargs!(dkions_input; args...)
    dkions_input["output"]["run_name"] = dkions_name
    # Suppress console output while running
    phi = undef
    quietoutput() do
        # run simulation
        run_moment_kinetics(dkions_input)

        # now run the coll_krook simulation restarting from the dkions output
        name_of_restart_file = dkions_name * ".dfns.h5"
        run_moment_kinetics(coll_krook_input, restart = joinpath(
            realpath(dkions_input["output"]["base_directory"]),
            dkions_name, name_of_restart_file))
    end

    if global_rank[] == 0
        quietoutput() do
            # Load and analyse output
            #########################

            path = joinpath(realpath(coll_krook_input["output"]["base_directory"]), coll_krook_name)

            # open the output file(s)
            run_info = get_run_info_no_setup(path)

            # load fields data
            phi_zrt = postproc_load_variable(run_info, "phi")

            close_run_info(run_info)
            
            phi = phi_zrt[:,1,:]
        end

        # Regression test
        actual_phi = phi[begin:3:end, end]
        if expected_phi == nothing
            # Error: no expected input provided
            println("data tested would be: ", actual_phi)
            @test false
        else
            @test isapprox(actual_phi, expected_phi, rtol=rtol, atol=atol)
        end
    end
end

function runtests()
    # Create a temporary directory for test output
    test_output_directory = "temptest" #get_MPI_tempdir()

    @testset "coll_krook tests" verbose=use_verbose begin
        println("coll_krook tests")
        @testset "coll_krook_test_n1.0" begin
            dkions_n1["output"]["base_directory"] = test_output_directory
            coll_krook_n1["output"]["base_directory"] = test_output_directory
            run_test_with_restart(dkions_n1, coll_krook_n1,
                        [-0.2046469802477466, -0.05530425832122674, -0.020117501843671098,
                         0.014079635381095499, 0.02353343350197394, 0.020308533092429817,
                         0.01688530472524431, 0.012863146809769225, 0.0058363528791389035,
                         0.001211398196332593, -0.004790201363386236,
                         -0.01018420106773388, -0.013477464776868073,
                         -0.017127384191417672, -0.018219901840220355,
                         -0.01819240071496478, -0.016378794527952704,
                         -0.013965713892741094, -0.008413431238362148,
                         -0.00412042026953702, 0.002462142173716437, 0.009630826656712834,
                         0.01512556304927134, 0.023991652672705283, 0.02935301299794284,
                         0.036261432594185676, 0.042631517592974594, 0.04691632563337594,
                         0.05293439880712908, 0.056073693160730964, 0.05954898736192524,
                         0.06209903063728896, 0.06336936274599415, 0.06428491070179797,
                         0.06414882581903676, 0.0631043092253426, 0.061083306253805536,
                         0.058981438923665065, 0.054546834319236716, 0.05117119678409705,
                         0.04589365600054886, 0.03987867210625121, 0.035035547735049875,
                         0.026665268711581903, 0.02122999083632228, 0.013758382983831658,
                         0.00639589830411427, 0.0012046760500256425,
                         -0.006360362443270581, -0.010352778371437185,
                         -0.014640998048119802, -0.017397964856249865,
                         -0.01832754250906425, -0.01778378999601368, -0.01621914030343568,
                         -0.01273896065739589, -0.00789034517036057,
                         -0.0037536060471417784, 0.0035434806428106752,
                         0.008130570843347947, 0.01388603320663947, 0.018929071077985304,
                         0.02100648769657795, 0.020876165516025908, 0.005205697429748979,
                         -0.027840842780850902, -0.08764314814002391]
                       )
        end
        @testset "coll_krook_test_n10" begin
            dkions_n10["output"]["base_directory"] = test_output_directory
            coll_krook_n10["output"]["base_directory"] = test_output_directory
            run_test_with_restart(dkions_n10, coll_krook_n10,
                        [0.851687966228535, 1.116277954515732, 1.1580549326913716,
                         1.180340181509914, 1.185321320847639, 1.1801958584762111,
                         1.1716568977992212, 1.162548423720606, 1.1467616275465597,
                         1.1360995604711035, 1.1229702077551706, 1.1105545034847821,
                         1.1028330432970397, 1.0927049017809243, 1.086747225832894,
                         1.0810536786157094, 1.079926430992624, 1.0824149557550724,
                         1.0930278230275936, 1.1034423274708096, 1.1215465752520741,
                         1.1427588244654252, 1.1596312091683758, 1.1872745334498567,
                         1.2040499670895282, 1.2254757777950696, 1.244977037291723,
                         1.2578665889842422, 1.2757090598266791, 1.284852278820068,
                         1.2948588797291771, 1.3020683217142972, 1.305633229401966,
                         1.3081815396779215, 1.3078084731382034, 1.3048798878755854,
                         1.2992114068179024, 1.293224227270306, 1.2804231932153907,
                         1.270512685159299, 1.2548187824523915, 1.2365920081066317,
                         1.221708878631926, 1.1956430040586596, 1.178645835505236,
                         1.1553773788654427, 1.1330500312095921, 1.1179125616538623,
                         1.0978441382468904, 1.0888046329489642, 1.0815846364584816,
                         1.0798060937659721, 1.0818974994479669, 1.0896820475475255,
                         1.0958342195047222, 1.1044448416781751, 1.1158884569907206,
                         1.1250102059593083, 1.141499032382221, 1.1516590327676477,
                         1.1654097420473313, 1.1758861806716934, 1.1827851823895814,
                         1.1837397578974433, 1.1775353587001165, 1.147893096233605,
                         1.0744540734983172]
                       )
        end
        @testset "coll_krook_test_n100" begin
            dkions_n100["output"]["base_directory"] = test_output_directory
            coll_krook_n100["output"]["base_directory"] = test_output_directory
            run_test_with_restart(dkions_n100, coll_krook_n100,
                    [2.99720065915843, 3.2783464949434187, 3.329048879810596,
                     3.351713861455079, 3.347795584139061, 3.3271884011373345,
                     3.308208903975797, 3.2928597224864284, 3.26937933491104,
                     3.255945828049674, 3.244111471394069, 3.2396471125136475,
                     3.2426953229753455, 3.2591019897058042, 3.276390665549256,
                     3.3064016896324895, 3.3420967510375856, 3.370409072873624,
                     3.416912043466683, 3.4449658273933355, 3.480785500900651,
                     3.5132063389955963, 3.534721570030344, 3.5648072813447573,
                     3.580723870663843, 3.5990909560196904, 3.614148642054472,
                     3.623354782860919, 3.6351834329464783, 3.6408679062678533,
                     3.646795862288444, 3.6508977994398615, 3.6528661785079843,
                     3.6542570655870623, 3.654052037271866, 3.652458137403503,
                     3.649289318815926, 3.645852372077744, 3.6381440306734505,
                     3.6318450520009726, 3.621222510064117, 3.6078511725001263,
                     3.5959973332241315, 3.5729378695202794, 3.5559782656528927,
                     3.5295898156805414, 3.4992725870611134, 3.4744503956344506,
                     3.4309310862226705, 3.4023808240315447, 3.3633514613154953,
                     3.3257336167968563, 3.300495249600015, 3.26703645992425,
                     3.252472199193099, 3.241288902094697, 3.240575545816134,
                     3.245372397333151, 3.2623788527772604, 3.276150116492363,
                     3.2972525293914874, 3.316480280913688, 3.33284227283612,
                     3.351992117086336, 3.3518572988164608, 3.3164960017666,
                     3.221075723912204]
                   )
        end
    end

    if global_rank[] == 0
        # Delete output directory to avoid using too much disk space
        rm(realpath(test_output_directory); recursive=true)
    end
end

end

using .coll_krook_tests

coll_krook_tests.runtests()
