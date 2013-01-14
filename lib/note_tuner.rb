class NoteTuner
  FACTORY = NoteFactory.new

  def new options, key
    plain_note = Note.new options.merge key: key

    closest = key.note plain_note.midi_number

    diff = closest.diff plain_note

    debugger
    new_note = key.note closest.midi_number, diff.cents, TunedNote

    new_note

  end
end
