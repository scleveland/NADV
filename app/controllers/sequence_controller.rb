class SequenceController < ApplicationController
  
  def index
  
  end
  def translate
    @seq =  Bio::Sequence::NA.new(params[:nuc_seq])
    #@aaseq = @seq.translate
    @aaseq=""
    @aaseq_w_space=""
    window_size = 3
    step_size   = 3

    # this will print all the codons as "aug", "gca", "ccg", "ucc", "aga"
    @seq.window_search(window_size, step_size) do |subseq|
      @aaseq_w_space = @aaseq_w_space + subseq.translate + "__"
      @aaseq = @aaseq + subseq.translate
    end

  end
  
  def download
    seq =  Bio::Sequence::NA.new(params[:nuc_seq])
    out_string =""
    aaseq=""
    window_size = 3
    step_size   = 3
    # this will print all the codons as "aug", "gca", "ccg", "ucc", "aga"
    seq.window_search(window_size, step_size) do |subseq|
      aaseq = aaseq + subseq.translate + "\s\s"
    end
    rows = (seq.length/30).abs 
    i = 0  
    # Create a new file and write to it   
    while i < rows  do 
      out_string = out_string + ((10*i)+1).to_s + "\t" + aaseq[(30*i)..(30*i+30-1)] + "\n"
      out_string = out_string + ((30*i)+1).to_s + "\t" + seq.upcase[(30*i)..(30*i+30-1)] + "\n"
      i +=1  
    end 
    #render :file=> out_string
    send_data(out_string,
    :type => 'text/csv; charset=utf-8; header=present',
    :filename => "output.txt")
  end
end