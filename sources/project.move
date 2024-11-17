module MedicalRecordManagement::MedicalRecordManagement {

    use aptos_framework::signer;

    /// Struct representing a medical record.
    struct MedicalRecord has store, key {
        data_hash: vector<u8>,        // Hash of the medical record data
        authorized_provider: address, // Address of the authorized healthcare provider
    }

    /// Function to create a medical record owned by the patient.
    public fun create_record(patient: &signer, data_hash: vector<u8>) {
        let patient_address = signer::address_of(patient);

        // Ensure a medical record doesn't already exist for the patient
        assert!(!exists<MedicalRecord>(patient_address), 1);

        // Create and store the medical record
        let record = MedicalRecord {
            data_hash,
            authorized_provider: @0x0, // No provider authorized initially
        };
        move_to(patient, record);
    }

    /// Function to grant access to a healthcare provider for the medical record.
    public fun grant_access(patient: &signer, provider: address) acquires MedicalRecord {
        let patient_address = signer::address_of(patient);

        // Borrow the patient's medical record
        let record = borrow_global_mut<MedicalRecord>(patient_address);

        // Set the authorized provider
        record.authorized_provider = provider;
    }
}
