RSpec.describe Rares do
  it "has a version number" do
    expect(Rares::VERSION).not_to be nil
  end

  let!(:project_folder) { Dir.pwd + "/spec/project" }
  let!(:recipe_folder) { Dir.pwd + "/spec/recipe" }
  let!(:sample_folder) { Dir.pwd + "/spec/samples" }

  it "should work" do
    main = Rares::Main.new(recipe_folder, project_folder)

    allow(main).to receive(:no?).and_return(false)

    clean
    expect(File.read("#{project_folder}/replaced_file.txt")).to eq("initial")

    main.perform

    compare_with_sample("routes.rb")
    compare_with_sample("package.json")

    expect(File.read("#{project_folder}/first_file.txt")).to eq("first")
    expect(File.read("#{project_folder}/level1/level2/second_file.txt")).to eq("second")
    expect(File.read("#{project_folder}/third_file.txt")).to eq("third\n")
    expect(File.read("#{project_folder}/replaced_file.txt")).to eq("replaced")
  end

  def clean
    FileUtils.rm_rf project_folder
    FileUtils.cp_r Dir.pwd + "/spec/project_files", project_folder
  end

  def compare_with_sample(path)
    expect(File.read("#{project_folder}/#{path}")).to eq File.read("#{sample_folder}/#{path}")
  end
end
